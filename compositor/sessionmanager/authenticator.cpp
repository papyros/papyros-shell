/****************************************************************************
 * This file is part of Hawaii.
 *
 * Copyright (C) 2015-2016 Pier Luigi Fiorini
 *
 * Author(s):
 *    Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * $BEGIN_LICENSE:GPL2+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
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

#include "authenticator.h"

#include <security/pam_appl.h>
#include <unistd.h>
#include <pwd.h>

Authenticator::Authenticator(QObject *parent)
    : QObject(parent)
    , m_response(Q_NULLPTR)
{
}

Authenticator::~Authenticator()
{
}

void Authenticator::authenticate(const QString &password)
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

    Q_EMIT authenticationSucceded();
}

int Authenticator::conversationHandler(int num, const pam_message **message,
                                       pam_response **response, void *data)
{
    Q_UNUSED(num);
    Q_UNUSED(message);

    Authenticator *self = static_cast<Authenticator *>(data);
    *response = self->m_response;
    return PAM_SUCCESS;
}

#include "moc_authenticator.cpp"
