/****************************************************************************
 *
 * Papyros Shell - The desktop shell for Papyros following Material Design
 * Copyright (C) 2015 Michael Spencer <sonrisesoftware@gmail.com>
 *               2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * Author(s):
 *    Michael Spencer
 *    Pier Luigi Fiorini
 *
 * $BEGIN_LICENSE:GPL3-PAPYROS-HAWAII$
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3 or any later version accepted
 * by Michael Spencer and Pier Luigi Fiorini, which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * Any modifications to this file must keep this entire header intact.
 *
 * The interactive user interfaces in modified source and object code
 * versions of this program must display Appropriate Legal Notices,
 * as required under Section 5 of the GNU General Public License version 3.
 *
 * In accordance with Section 7(b) of the GNU General Public License
 * version 3, these Appropriate Legal Notices must retain the display of the
 * "Powered by Papyros and Hawaii" logo.  If the display of the logo is not
 * reasonably feasible for technical reasons, the Appropriate Legal Notices
 * must display the words "Powered by Papyros and Hawaii".
 *
 * In accordance with Section 7(c) of the GNU General Public License
 * version 3, modified source and object code versions of this program
 * must be marked in reasonable ways as different from the original version.
 *
 * In accordance with Section 7(d) of the GNU General Public License
 * version 3, neither the "Papyros" and "Hawaii" names, nor the names of any
 * project that is related to them, nor the names of their contributors may be
 * used to endorse or promote products derived from this software without
 * specific prior written permission.
 *
 * In accordance with Section 7(e) of the GNU General Public License
 * version 3, this license does not grant any license or rights to use the
 * "Papyros" and "Hawaii" names or logos, nor any other trademark.
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


#include "compositorlauncher.h"
#include "cmakedirs.h"

#include <QtCore/QCoreApplication>
#include <QtCore/QDir>
#include <QtCore/QFile>
#include <QtCore/QStandardPaths>
#include <QDebug>

Q_GLOBAL_STATIC(CompositorLauncher, s_compositorLauncher)

CompositorLauncher::CompositorLauncher(QObject *parent)
    : QObject(parent)
    , m_mode(UnknownMode)
    , m_hardware(UnknownHardware)
    , m_hasLibInputPlugin(false)
{
}

CompositorLauncher *CompositorLauncher::instance()
{
    return s_compositorLauncher();
}

void CompositorLauncher::start()
{
    // Try to detect mode and hardware
    detectHardware();
    detectMode();
    if (m_mode == UnknownMode) {
        qWarning() << "No mode detected, please manually specify one!";
        QCoreApplication::quit();
        return;
    }

    // Detect whether we have libinput
    detectLibInput();

    // Start the process
    startProcess("greenisland", compositorArgs(), compositorEnv());

    // Set environment so that applications will inherit it
    setupEnvironment();
}

void CompositorLauncher::stop()
{
    if (!m_process)
        return;

    qDebug() << "Stopping the compositor";

    m_process->terminate();
    if (!m_process->waitForFinished())
        m_process->kill();
    m_process->deleteLater();
    m_process = Q_NULLPTR;
    Q_EMIT stopped();
}

void CompositorLauncher::startProcess(const QString &command, const QStringList &args,
        QProcessEnvironment environment)
{
    qDebug() << "Starting:" << command << args.join(' ');
    if (m_process) {
        qWarning() << "Compositor already running!";
        return;
    }

    m_process = new QProcess(this);
    m_process->setProgram(command);
    m_process->setArguments(args);
    m_process->setProcessChannelMode(QProcess::ForwardedChannels);
    m_process->setProcessEnvironment(environment);
    connect(m_process, SIGNAL(error(QProcess::ProcessError)),
            this, SLOT(compositorError(QProcess::ProcessError)));
    connect(m_process, SIGNAL(finished(int,QProcess::ExitStatus)),
            this, SLOT(compositorFinished(int,QProcess::ExitStatus)));

    m_process->start();

    emit started();
}

void CompositorLauncher::detectMode()
{
    // Can't detect mode when it was forced by arguments
    if (m_mode != UnknownMode)
        return;

    // Detect Wayland
    if (qEnvironmentVariableIsSet("WAYLAND_DISPLAY")) {
        m_mode = WaylandMode;
        return;
    }

    // Detect X11
    if (qEnvironmentVariableIsSet("DISPLAY")) {
        m_mode = X11Mode;
        return;
    }

    // Detect eglfs since Qt 5.5
    if (qEnvironmentVariableIsSet("QT_QPA_EGLFS_INTEGRATION") || m_hardware != UnknownHardware) {
        m_mode = EglFSMode;
        return;
    }

    // Default to unknown mode
    m_mode = UnknownMode;
}

void CompositorLauncher::detectHardware()
{
    // Detect Broadcom
    bool found = deviceModel().startsWith(QStringLiteral("Raspberry"));
    if (!found) {
        QStringList paths = QStringList()
                << QStringLiteral("/usr/bin/vcgencmd")
                << QStringLiteral("/opt/vc/bin/vcgencmd")
                << QStringLiteral("/proc/vc-cma");
        found = pathsExist(paths);
    }
    if (found) {
        m_hardware = BroadcomHardware;
        return;
    }

    // TODO: Detect Mali
    // TODO: Detect Vivante

    // Detect DRM
    if (QDir(QStringLiteral("/sys/class/drm")).exists()) {
        m_hardware = DrmHardware;
        return;
    }

    // Unknown hardware
    m_hardware = UnknownHardware;
}

QString CompositorLauncher::deviceModel() const
{
    QFile file(QStringLiteral("/proc/device-tree/model"));
    if (file.open(QIODevice::ReadOnly)) {
        QString data = QString::fromUtf8(file.readAll());
        file.close();
        return data;
    }

    return QString();
}

bool CompositorLauncher::pathsExist(const QStringList &paths) const
{
    Q_FOREACH (const QString &path, paths) {
        if (QFile::exists(path))
            return true;
    }

    return false;
}

void CompositorLauncher::detectLibInput()
{
    // Do we have the libinput plugin?
    for (const QString &path: QCoreApplication::libraryPaths()) {
        QDir pluginsDir(path + QStringLiteral("/generic"));
        for (const QString &fileName: pluginsDir.entryList(QDir::Files)) {
            if (fileName == QStringLiteral("libqlibinputplugin.so")) {
                m_hasLibInputPlugin = true;
                break;
            }
        }
    }
}

QStringList CompositorLauncher::compositorArgs() const
{
    QStringList args;

    // Common arguments
    args << "--shell" << "io.papyros.shell";

    // Mode-specific arguments
    switch (m_mode) {
    case EglFSMode:
        if (m_hasLibInputPlugin)
            args << QStringLiteral("-plugin") << QStringLiteral("libinput");
        else
            args << QStringLiteral("-plugin") << QStringLiteral("EvdevMouse")
                 << QStringLiteral("-plugin") << QStringLiteral("EvdevKeyboard");
        break;
    default:
        break;
    }

    return args;
}

QProcessEnvironment CompositorLauncher::compositorEnv() const
{
    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();

    // Standard environment
    env.insert(QStringLiteral("QT_QPA_PLATFORMTHEME"), QStringLiteral("Material"));
    env.insert(QStringLiteral("QT_QUICK_CONTROLS_STYLE"), QStringLiteral("Material"));
    env.insert(QStringLiteral("XCURSOR_THEME"), QStringLiteral("Adwaita"));
    env.insert(QStringLiteral("XCURSOR_SIZE"), QStringLiteral("16"));
    env.insert(QStringLiteral("QSG_RENDER_LOOP"), QStringLiteral("windows"));

    // Specific environment
    switch (m_mode) {
    case EglFSMode:
        // General purpose distributions do not have the proper eglfs
        // integration and may want to build it out of tree, let them
        // specify a QPA plugin with an environment variable
        if (qEnvironmentVariableIsSet("PAPYROS_QPA_PLATFORM"))
            env.insert(QStringLiteral("QT_QPA_PLATFORM"), qgetenv("PAPYROS_QPA_PLATFORM"));
        else
            env.insert(QStringLiteral("QT_QPA_PLATFORM"), QStringLiteral("eglfs"));

        switch (m_hardware) {
        case BroadcomHardware:
            env.insert(QStringLiteral("QT_QPA_EGLFS_INTEGRATION"), QStringLiteral("eglfs_brcm"));
            break;
        default:
            env.insert(QStringLiteral("QT_QPA_EGLFS_INTEGRATION"), QStringLiteral("eglfs_kms"));
            env.insert(QStringLiteral("QT_QPA_EGLFS_KMS_CONFIG"),
                       QStandardPaths::locate(QStandardPaths::GenericDataLocation,
                                              QStringLiteral("papyros-shell/eglfs/eglfs_kms.json")));
            break;
        }

        if (m_hasLibInputPlugin)
            env.insert(QStringLiteral("QT_QPA_EGLFS_DISABLE_INPUT"), QStringLiteral("1"));
        break;
    case X11Mode:
        // TODO: Figure out why this was necessary and why it makes closing Qt apps freeze the shell
        // env.insert(QStringLiteral("QT_XCB_GL_INTEGRATION"), QStringLiteral("xcb_egl"));
        break;
    default:
        break;
    }

    return env;
}

void CompositorLauncher::setupEnvironment()
{
    // Make clients run on Wayland
    if (m_hardware == BroadcomHardware) {
        qputenv("QT_QPA_PLATFORM", QByteArray("wayland-brcm"));
        qputenv("QT_WAYLAND_HARDWARE_INTEGRATION", QByteArray("brcm-egl"));
        qputenv("QT_WAYLAND_CLIENT_BUFFER_INTEGRATION", QByteArray("brcm-egl"));
    } else {
        qputenv("QT_QPA_PLATFORM", QByteArray("wayland"));
    }
    qputenv("GDK_BACKEND", QByteArray("wayland"));

    qunsetenv("WAYLAND_DISPLAY");
}
