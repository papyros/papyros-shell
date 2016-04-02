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

#ifndef LOGINDBACKEND_H
#define LOGINDBACKEND_H

#include <QtCore/QLoggingCategory>
#include <QtDBus/QDBusConnection>

#include "loginmanagerbackend.h"

Q_DECLARE_LOGGING_CATEGORY(LOGIND_BACKEND)

class QDBusInterface;
class QDBusPendingCallWatcher;

class SessionManager;

class LogindBackend : public LoginManagerBackend
{
    Q_OBJECT
public:
    ~LogindBackend();

    static LogindBackend *create(SessionManager *sm,
                                 const QDBusConnection &connection = QDBusConnection::systemBus());

    QString name() const;

    void setIdle(bool value);

    void takeControl();
    void releaseControl();

    int takeDevice(const QString &path);
    void releaseDevice(int fd);

    void lockSession();
    void unlockSession();

    void requestLockSession();
    void requestUnlockSession();

    void locked();
    void unlocked();

    void switchToVt(int index);

private:
    LogindBackend();

    SessionManager *m_sessionManager;
    QDBusInterface *m_interface;
    QString m_sessionPath;
    int m_inhibitFd;

    void setupInhibitors();

private Q_SLOTS:
    void prepareForSleep(bool arg);
    void prepareForShutdown(bool arg);
    void getSession(QDBusPendingCallWatcher *watcher);
    void devicePaused(quint32 devMajor, quint32 devMinor, const QString &type);
};

#endif // LOGINDBACKEND_H
