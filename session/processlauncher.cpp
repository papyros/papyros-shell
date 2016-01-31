/****************************************************************************
 * This file is part of Hawaii.
 *
 * Copyright (C) 2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * Author(s):
 *    Pier Luigi Fiorini
 *
 * $BEGIN_LICENSE:GPL3-HAWAII$
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3 or any later version accepted
 * by Pier Luigi Fiorini, which shall act as a proxy defined in Section 14
 * of version 3 of the license.
 *
 * Any modifications to this file must keep this entire header intact.
 *
 * The interactive user interfaces in modified source and object code
 * versions of this program must display Appropriate Legal Notices,
 * as required under Section 5 of the GNU General Public License version 3.
 *
 * In accordance with Section 7(b) of the GNU General Public License
 * version 3, these Appropriate Legal Notices must retain the display of the
 * "Powered by Hawaii" logo.  If the display of the logo is not reasonably
 * feasible for technical reasons, the Appropriate Legal Notices must display
 * the words "Powered by Hawaii".
 *
 * In accordance with Section 7(c) of the GNU General Public License
 * version 3, modified source and object code versions of this program
 * must be marked in reasonable ways as different from the original version.
 *
 * In accordance with Section 7(d) of the GNU General Public License
 * version 3, neither the "Hawaii" name, nor the name of any project that is
 * related to it, nor the names of its contributors may be used to endorse or
 * promote products derived from this software without specific prior written
 * permission.
 *
 * In accordance with Section 7(e) of the GNU General Public License
 * version 3, this license does not grant any license or rights to use the
 * "Hawaii" name or logo, nor any other trademark.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

#include <QtCore/QProcess>
#include <QtCore/QStandardPaths>

#include <qt5xdg/xdgdesktopfile.h>

#include <QtDBus/QDBusConnection>
#include <QtDBus/QDBusError>

#include "processlauncher.h"
#include "sessionmanager.h"

Q_LOGGING_CATEGORY(LAUNCHER, "papyros.session.launcher")

ProcessLauncher::ProcessLauncher(SessionManager *sessionManager)
        : QDBusAbstractAdaptor(sessionManager), m_sessionManager(sessionManager)
{
}

ProcessLauncher::~ProcessLauncher() { closeApplications(); }

bool ProcessLauncher::registerInterface()
{
    QDBusConnection bus = QDBusConnection::sessionBus();

    if (!bus.registerObject(objectPath, this)) {
        qCWarning(LAUNCHER, "Couldn't register %s D-Bus object: %s", objectPath,
                  qPrintable(bus.lastError().message()));
        return false;
    }

    qCDebug(LAUNCHER) << "Registered" << interfaceName << "D-Bus interface";
    return true;
}

void ProcessLauncher::closeApplications()
{
    qCDebug(LAUNCHER) << "Terminate applications";

    // Terminate all process launched by us
    ApplicationMapIterator i(m_apps);
    while (i.hasNext()) {
        i.next();

        QString fileName = i.key();
        QProcess *process = i.value();

        i.remove();

        qCDebug(LAUNCHER) << "Terminating application from" << fileName << "with pid"
                          << process->pid();

        process->terminate();
        if (!process->waitForFinished())
            process->kill();
        process->deleteLater();
    }
}

bool ProcessLauncher::launchApplication(const QString &appId, const QStringList &urls)
{
    const QString fileName = QStandardPaths::locate(QStandardPaths::ApplicationsLocation,
                                                    appId + QStringLiteral(".desktop"));
    XdgDesktopFile *entry = XdgDesktopFileCache::getFile(fileName);
    if (!entry->isValid()) {
        qCWarning(LAUNCHER) << "No desktop entry found for" << appId;
        return false;
    }

    return launchEntry(entry, urls);
}

bool ProcessLauncher::launchDesktopFile(const QString &fileName, const QStringList &urls)
{
    XdgDesktopFile *entry = XdgDesktopFileCache::getFile(fileName);
    if (!entry->isValid()) {
        qCWarning(LAUNCHER) << "Failed to open desktop file" << fileName;
        return false;
    }

    return launchEntry(entry, urls);
}

bool ProcessLauncher::closeApplication(const QString &appId)
{
    const QString fileName = appId + QStringLiteral(".desktop");
    return closeEntry(fileName);
}

bool ProcessLauncher::closeDesktopFile(const QString &fileName)
{
    qCDebug(LAUNCHER) << "Closing application for" << fileName;
    return closeEntry(fileName);
}

bool ProcessLauncher::launchEntry(XdgDesktopFile *entry, const QStringList &urls)
{
    QStringList args = entry->expandExecString(urls);

    if (args.isEmpty())
        return false;

    if (entry->value("Terminal").toBool()) {
        QString term = getenv("TERM");
        if (term.isEmpty())
            term = "xterm";

        args.prepend("-e");
        args.prepend(term);
    }

    QString command = args.takeAt(0);

    qDebug() << "Launching" << args.join(" ") << "from" << entry->fileName();

    QProcess *process = new QProcess(this);
    process->setProgram(command);
    process->setArguments(args);
    process->setProcessChannelMode(QProcess::ForwardedChannels);
    m_apps[entry->fileName()] = process;
    connect(process, SIGNAL(finished(int) ), this, SLOT(finished(int) ));
    process->start();
    if (!process->waitForStarted()) {
        qCWarning(LAUNCHER, "Failed to launch \"%s\" (%s)", qPrintable(entry->fileName()),
                  qPrintable(entry->name()));
        return false;
    }

    qCDebug(LAUNCHER, "Launched \"%s\" (%s) with pid %lld", qPrintable(entry->fileName()),
            qPrintable(entry->name()), process->pid());

    return true;
}

bool ProcessLauncher::closeEntry(const QString &fileName)
{
    if (!m_apps.contains(fileName))
        return false;

    QProcess *process = m_apps[fileName];
    process->terminate();
    if (!process->waitForFinished())
        process->kill();
    m_apps.remove(fileName);
    process->deleteLater();
    return true;
}

void ProcessLauncher::finished(int exitCode)
{
    QProcess *process = qobject_cast<QProcess *>(sender());
    if (!process)
        return;

    QString fileName = m_apps.key(process);

    if (fileName.isNull())
        return;

    XdgDesktopFile *entry = XdgDesktopFileCache::getFile(fileName);
    if (entry) {
        qCDebug(LAUNCHER) << "Application for" << fileName << "finished with exit code" << exitCode;
        m_apps.remove(fileName);
        process->deleteLater();
    }
}

#include "moc_processlauncher.cpp"
