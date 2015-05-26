/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 *
 * Copyright (C) 2015 Bogdan Cuza <bogdan.cuza@hotmail.com>
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

#ifndef SESSIONMANAGER_H
#define SESSIONMANAGER_H

#include <QObject>

#include <QDBusInterface>
#include <QQmlEngine>
#include <QJSEngine>

struct pam_message;
struct pam_response;

class SessionManager : public QObject
{
    Q_OBJECT

public:
    SessionManager(QObject *parent = 0);

    static QObject *qmlSingleton(QQmlEngine *engine, QJSEngine *scriptEngine);

public slots:
    void powerOff();
    void reboot();
    void logout();

    void authenticate(const QString &password);

signals:
    void authenticationSucceeded();
    void authenticationFailed();
    void authenticationError();

private:
    QDBusInterface logind;
    pam_response *m_response;

    static int conversationHandler(int num, const pam_message **message,
                                   pam_response **response, void *data);

};

#endif // SESSIONMANAGER_H
