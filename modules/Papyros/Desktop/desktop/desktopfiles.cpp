/*
 * QML Desktop - Set of tools written in C++ for QML
 *
 * Copyright (C) 2014 Bogdan Cuza <bogdan.cuza@hotmail.com>
 *               2015 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "desktopfiles.h"

#include <QDir>

Q_GLOBAL_STATIC(DesktopFiles, s_desktopFiles)

DesktopFiles::DesktopFiles(QObject *parent)
        : QObject(parent) {
    QStringList paths; paths << "~/.local/share/applications"
                             << "/usr/local/share/applications"
                             << "/usr/share/applications";
    QStringList filter; filter << "*.desktop";

    QStringList files = filesInPaths(paths, filter);

    for (QString fileName : files) {
        DesktopFile *desktopFile = new DesktopFile(fileName, this);

        if (desktopFile->isShown())
            desktopList << desktopFile;
    }

    desktopList.sort(DesktopFiles::compare);

    fileWatcher = new QFileSystemWatcher(files, this);
    dirWatcher = new QFileSystemWatcher(paths, this);

    connect(fileWatcher, &QFileSystemWatcher::fileChanged,
            this, &DesktopFiles::onFileChanged);
    connect(dirWatcher, &QFileSystemWatcher::directoryChanged,
            this, &DesktopFiles::onDirectoryChanged);
}

QStringList DesktopFiles::filesInPaths(QStringList paths, QStringList filters)
{
    QStringList allFiles;

    for (QString path : paths) {
        QStringList fileNames = QDir(path).entryList(filters);

        for (QString fileName : fileNames) {
            allFiles << path + "/" + fileName;
        }
    }

    return allFiles;
}

void DesktopFiles::onFileChanged(const QString &path)
{
    if (QFile::exists(path)) {
        for (DesktopFile *desktopFile : desktopList) {
            if (desktopFile->m_path == path) {
                desktopFile->load();
                break;
            }
        }
    } else {
        for (DesktopFile *desktopFile : desktopList) {
            if (desktopFile->m_path == path) {
                desktopList.removeOne(desktopFile);
                fileWatcher->removePath(path);
                delete desktopFile;

                break;
            }
        }
    }

    desktopList.sort(DesktopFiles::compare);

    emit desktopFilesChanged(desktopFiles());
}

DesktopFile *DesktopFiles::desktopFileForPath(const QString &path)
{
    for (DesktopFile *desktopFile : desktopList) {
        if (desktopFile->m_path == path)
            return desktopFile;
    }

    return nullptr;
}

void DesktopFiles::onDirectoryChanged(const QString &directory)
{
    QStringList files = QDir(directory).entryList(QStringList() << "*.desktop");

    for (QString file : files) {
        QString path = directory + "/" + file;

        if (desktopFileForPath(path) == nullptr) {
            desktopList << new DesktopFile(path, this);
            desktopList.sort(DesktopFiles::compare);

            emit desktopFilesChanged(desktopFiles());

            fileWatcher->addPath(path);
        }
    }
}

bool DesktopFiles::compare(const DesktopFile *a, const DesktopFile *b)
{
    return a->name().toLower() < b->name().toLower();
}

int DesktopFiles::indexOfName(QString name)
{
    for (int i = 0; i < desktopList.length(); i++) {
        DesktopFile *desktopFile = desktopList.at(i);

        if (desktopFile->name().startsWith(name, Qt::CaseInsensitive))
            return i;
    }
    return -1;
}

void DesktopFiles::closeApplications()
{
    // Terminate all process launched by us
    ApplicationMapIterator i(m_apps);
    while (i.hasNext()) {
        i.next();

        QString fileName = i.key();
        QProcess *process = i.value();

        i.remove();

        qDebug() << "Terminating application from" << fileName << "with pid" << process->pid();

        process->terminate();
        if (!process->waitForFinished())
            process->kill();
        process->deleteLater();
    }
}

bool DesktopFiles::launchApplication(XdgDesktopFile *entry, const QStringList& urls)
{
    QStringList args = entry->expandExecString(urls);

    if (args.isEmpty())
        return false;

    if (entry->value("Terminal").toBool())
    {
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
    connect(process, SIGNAL(finished(int)), this, SLOT(processFinished(int)));
    process->start();
    if (!process->waitForStarted()) {
        qWarning("Failed to launch \"%s\" (%s)",
                  qPrintable(entry->fileName()),
                  qPrintable(entry->name()));
        return false;
    }

    qDebug("Launched \"%s\" (%s) with pid %lld",
            qPrintable(entry->fileName()),
            qPrintable(entry->name()),
            process->pid());

    return true;
}

bool DesktopFiles::closeApplication(const QString &fileName)
{
    if (!m_apps.contains(fileName))
        return false;

    QProcess *process = m_apps[fileName];
    process->terminate();
    if (!process->waitForFinished())
        process->kill();
    return true;
}

void DesktopFiles::processFinished(int exitCode)
{
    QProcess *process = qobject_cast<QProcess *>(sender());
    if (!process)
        return;

    QString fileName = m_apps.key(process);
    XdgDesktopFile *entry = XdgDesktopFileCache::getFile(fileName);
    if (entry) {
        qDebug() << "Application for" << fileName << "finished with exit code" << exitCode;
        m_apps.remove(fileName);
        process->deleteLater();
    }
}

DesktopFiles *DesktopFiles::sharedInstance()
{
    return s_desktopFiles();
}

QObject* DesktopFiles::qmlSingleton(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return s_desktopFiles();
}
