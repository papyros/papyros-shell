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

#include <QtCore/QCoreApplication>
#include <QtCore/QCommandLineParser>
#include <QDebug>
#include "compositorlauncher.h"
#include "sessionmanager.h"
#include "config.h"

#include "sigwatch/sigwatch.h"

#include <unistd.h>

#define TR(x) QT_TRANSLATE_NOOP("Command line parser", QStringLiteral(x))

int main(int argc, char *argv[])
{
    // Application
    QCoreApplication app(argc, argv);
    app.setApplicationName(QStringLiteral("Papyros Shell"));
    app.setApplicationVersion(QStringLiteral(PAPYROS_SHELL_VERSION_STRING));
    app.setOrganizationName(QStringLiteral("Papyros"));

    // Restart with D-Bus session if necessary
    if (qEnvironmentVariableIsEmpty("DBUS_SESSION_BUS_ADDRESS")) {
        qDebug() << "No D-Bus session bus available, respawning with dbus-launch...";

        QStringList args = QStringList()
                << QStringLiteral("--exit-with-session")
                << QCoreApplication::arguments();

        char **const argv_pointers = new char *[args.count() + 2];
        char **p = argv_pointers;

        *p = ::strdup("dbus-launch");
        ++p;

        for (const QString &arg: args) {
            *p = new char[arg.length() + 1];
            ::strcpy(*p, qPrintable(arg));
            ++p;
        }

        *p = 0;

        // Respawn with D-Bus session bus
        if (::execvp(argv_pointers[0], argv_pointers) == -1) {
            // If we are here execvp failed so we cleanup and bail out
            qWarning("Failed to respawn the session: %s", strerror(errno));

            p = argv_pointers;
            while (*p != 0)
                delete [] *p++;
            delete [] argv_pointers;

            ::exit(EXIT_FAILURE);
        }

        ::exit(EXIT_SUCCESS);
    }

    CompositorLauncher *launcher = CompositorLauncher::instance();

    // Session manager
    SessionManager *sessionManager = SessionManager::instance();
    if (!sessionManager->initialize())
        return 1;

    // Unix signals watcher
    UnixSignalWatcher sigwatch;
    sigwatch.watchForSignal(SIGINT);
    sigwatch.watchForSignal(SIGTERM);

    // Log out the session for SIGINT and SIGTERM
    QObject::connect(&sigwatch, &UnixSignalWatcher::unixSignal, [sessionManager](int signum) {
        qDebug() << "Log out caused by signal" << signum;
        sessionManager->logOut();
    });


    // Start the compositor
    launcher->start();

    return app.exec();
}
