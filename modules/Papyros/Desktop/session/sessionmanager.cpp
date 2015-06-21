/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 *
 * Copyright (C) 2015 Bogdan Cuza <bogdan.cuza@hotmail.com>
 *               2015 Michael Spencer <sonrisesoftware@gmail.com>
 *               2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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

#include "sessionmanager.h"

#include "desktop/desktopfiles.h"

#include <security/pam_appl.h>
#include <unistd.h>
#include <pwd.h>

SessionManager::SessionManager(QObject *parent)
        : QObject(parent),
          logind("org.freedesktop.login1", "/org/freedesktop/login1", "org.freedesktop.login1.Manager", QDBusConnection::systemBus()),
          m_response(nullptr)
{
    // Nothing needed here
}

void SessionManager::reboot()
{
    logind.call("Reboot", true);
}

void SessionManager::powerOff()
{
    logind.call("PowerOff", true);
}

void SessionManager::logOut()
{
    // Close all applications we launched
    DesktopFiles::sharedInstance()->closeApplications();

    // TODO: Once we have VT support
    // Make sure the vt handler is destroyed
    // m_vtHandler->deleteLater();

    // Exit
    QCoreApplication::quit();
}

// Based on code from Hawaii desktop
void SessionManager::authenticate(const QString &password)
{
    const pam_conv conversation = { conversationHandler, this };
    pam_handle_t *handle = Q_NULLPTR;

    passwd *pwd = getpwuid(getuid());
    if (!pwd) {
        Q_EMIT authenticationError();
        return;
    }

    int retval = pam_start("su", pwd->pw_name, &conversation, &handle);
    if (retval != PAM_SUCCESS) {
        qWarning("pam_start returned %d", retval);
        Q_EMIT authenticationError();
        return;
    }

    m_response = new pam_response;
    m_response[0].resp = strdup(qPrintable(password));
    m_response[0].resp_retcode = 0;

    retval = pam_authenticate(handle, 0);
    if (retval != PAM_SUCCESS) {
        if (retval == PAM_AUTH_ERR) {
            Q_EMIT authenticationFailed();
        } else {
            qWarning("pam_authenticate returned %d", retval);
            Q_EMIT authenticationError();
        }

        return;
    }

    retval = pam_end(handle, retval);
    if (retval != PAM_SUCCESS) {
        qWarning("pam_end returned %d", retval);
        Q_EMIT authenticationError();
        return;
    }

    Q_EMIT authenticationSucceeded();
}

int SessionManager::conversationHandler(int num, const pam_message **message,
                                       pam_response **response, void *data)
{
    Q_UNUSED(num);
    Q_UNUSED(message);

    SessionManager *self = static_cast<SessionManager *>(data);
    *response = self->m_response;
    return PAM_SUCCESS;
}

QObject* SessionManager::qmlSingleton(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    SessionManager *sessionManager = new SessionManager();
    return sessionManager;
}
