/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 *
 * Copyright (C) 2016 Michael Spencer <sonrisesoftware@gmail.com>
 *               2012-2016 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include <QtCore/QLoggingCategory>
#include <QtCore/QCommandLineParser>
#include <QtCore/QFileInfo>
#include <QtCore/QStandardPaths>
#include <QtWidgets/QApplication>

#include <Hawaii/greenisland_version.h>

#include "application.h"
#include "config.h"
#include "gitsha1.h"

#if HAVE_SYS_PRCTL_H
#include <sys/prctl.h>
#endif

#define TR(x) QT_TRANSLATE_NOOP("Command line parser", QStringLiteral(x))

static void disablePtrace()
{
#if HAVE_PR_SET_DUMPABLE
    // Allow ptrace when running inside gdb
    const qint64 pid = QCoreApplication::applicationPid();
    const QFileInfo process(QStringLiteral("/proc/%1/exe").arg(pid));
    if (process.isSymLink() && process.symLinkTarget().endsWith(QLatin1String("/gdb")))
        return;

    ::prctl(PR_SET_DUMPABLE, 0);
#endif
}

static void setupEnvironment()
{
    // Set defaults
    if (qEnvironmentVariableIsEmpty("XDG_DATA_DIRS"))
        qputenv("XDG_DATA_DIRS", QByteArrayLiteral("/usr/local/share/:/usr/share/"));
    if (qEnvironmentVariableIsEmpty("XDG_CONFIG_DIRS"))
        qputenv("XDG_CONFIG_DIRS", QByteArrayLiteral("/etc/xdg"));

    // Environment
    qputenv("QT_QPA_PLATFORMTHEME", QByteArrayLiteral("Papyros"));
    qputenv("QT_QUICK_CONTROLS_STYLE", QByteArrayLiteral("Material"));
    qputenv("QT_LABS_CONTROLS_STYLE", QByteArrayLiteral("material"));
    qputenv("XCURSOR_THEME", QByteArrayLiteral("papyros"));
    qputenv("XCURSOR_SIZE", QByteArrayLiteral("16"));
    qputenv("XDG_MENU_PREFIX", QByteArrayLiteral("papyros-"));
    qputenv("XDG_CURRENT_DESKTOP", QByteArrayLiteral("X-Papyros"));
}

int main(int argc, char *argv[])
{
    // Disable ptrace except for gdb
    disablePtrace();

    // Setup the environment
    setupEnvironment();

    // Application
    QApplication app(argc, argv);
    app.setApplicationName(QStringLiteral("Papyros"));
    app.setApplicationVersion(PPAPYROS_VERSION_STRING);
    app.setOrganizationName(QStringLiteral("Papyros"));
    app.setOrganizationDomain(QStringLiteral("papyros.io"));
#if QT_VERSION >= QT_VERSION_CHECK(5, 6, 0)
    app.setAttribute(Qt::AA_EnableHighDpiScaling);
    app.setFallbackSessionManagementEnabled(false);
#endif
    app.setQuitOnLastWindowClosed(false);

    // Command line parser
    QCommandLineParser parser;
    parser.setApplicationDescription(TR("The desktop shell for Papyros following Material Design"));
    parser.addHelpOption();
    parser.addVersionOption();

    // Wayland socket
    QCommandLineOption socketOption(QStringLiteral("wayland-socket-name"),
                                    TR("Wayland socket"), TR("name"));
    parser.addOption(socketOption);

    // Nested mode
    QCommandLineOption nestedOption(QStringList() << QStringLiteral("n") << QStringLiteral("nested"),
                                    TR("Nest into a compositor that supports _wl_fullscreen_shell"));
    parser.addOption(nestedOption);

    // Fake screen configuration
    QCommandLineOption fakeScreenOption(QStringLiteral("fake-screen"),
                                        TR("Use fake screen configuration"),
                                        TR("filename"));
    parser.addOption(fakeScreenOption);

#if DEVELOPMENT_BUILD
    // Load shell from an arbitrary path
    QCommandLineOption qmlOption(QStringLiteral("qml"),
                                 QStringLiteral("Load a shell main QML file"),
                                 QStringLiteral("filename"));
    parser.addOption(qmlOption);
#endif

    // Parse command line
    parser.process(app);

    // Restart with D-Bus session if necessary
    if (qEnvironmentVariableIsEmpty("DBUS_SESSION_BUS_ADDRESS")) {
        qCritical("No D-Bus session bus available, please run Papyros with dbus-launch.");
        return 1;
    }

    // Arguments
    bool nested = parser.isSet(nestedOption);
    QString socket = parser.value(socketOption);
    QString fakeScreenData = parser.value(fakeScreenOption);

    // Nested mode requires running from Wayland and a socket name
    // and fake screen data cannot be used
    if (nested) {
        if (!QGuiApplication::platformName().startsWith(QStringLiteral("greenisland"))) {
            qCritical("Nested mode only make sense when running on Wayland.\n"
                      "Please pass the \"-platform greenisland\" argument.");
            return 1;
        }

        if (socket.isEmpty()) {
            qCritical("Nested mode requires you to specify a socket name.\n"
                      "Please specify it with the \"--wayland-socket-name\" argument.");
            return 1;
        }

        if (!fakeScreenData.isEmpty()) {
            qCritical("Fake screen configuration cannot be used when nested");
            return 1;
        }
    }

    // Print version information
    qDebug("== Papyros Compositor v%s (Green Island v%s) ==\n"
           "** http://papyros.io\n"
           "** Bug reports to: https://github.com/papyros/papyros-shell/issues\n"
           "** Build: %s-%s",
           PAPYROS_VERSION_STRING, GREENISLAND_VERSION_STRING,
           PAPYROS_VERSION_STRING, GIT_REV);

    // Application
    Application *papyros = new Application();
    papyros->setScreenConfiguration(fakeScreenData);

    // Create the compositor and run
    bool urlAlreadySet = false;
#if DEVELOPMENT_BUILD
    if (parser.isSet(qmlOption)) {
        urlAlreadySet = true;
        papyros->setUrl(QUrl::fromLocalFile(parser.value(qmlOption)));
    }
#endif
    if (!urlAlreadySet)
        papyros->setUrl(QUrl(QStringLiteral("qrc:/Compositor.qml")));
    QCoreApplication::postEvent(papyros, new StartupEvent());

    return app.exec();
}
