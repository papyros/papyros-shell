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

#ifndef AUTHENTICATOR_H
#define AUTHENTICATOR_H

#include <QtCore/QObject>

struct pam_message;
struct pam_response;

class Authenticator : public QObject
{
    Q_OBJECT
public:
    Authenticator(QObject *parent = 0);
    ~Authenticator();

public Q_SLOTS:
    void authenticate(const QString &password);

Q_SIGNALS:
    void authenticationSucceded();
    void authenticationFailed();
    void authenticationError();

private:
    pam_response *m_response;

    static int conversationHandler(int num, const pam_message **message,
                                   pam_response **response, void *data);
};

#endif // AUTHENTICATOR_H
