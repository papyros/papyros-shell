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

#ifndef SESSIONMANAGER_H
#define SESSIONMANAGER_H

#include <QtCore/QObject>
#include <QtCore/QLoggingCategory>
#include <QtCore/QThread>
#include <QtQml/QJSValue>

Q_DECLARE_LOGGING_CATEGORY(SESSION_MANAGER)

class Authenticator;
class CustomAuthenticator;
class LoginManager;
class PowerManager;
class ScreenSaver;

class SessionManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool idle READ isIdle WRITE setIdle NOTIFY idleChanged)
    Q_PROPERTY(bool locked READ isLocked NOTIFY lockedChanged)
    Q_PROPERTY(bool canLock READ canLock CONSTANT)
    Q_PROPERTY(bool canStartNewSession READ canStartNewSession CONSTANT)
    Q_PROPERTY(bool canLogOut READ canLogOut CONSTANT)
    Q_PROPERTY(bool canPowerOff READ canPowerOff CONSTANT)
    Q_PROPERTY(bool canRestart READ canRestart CONSTANT)
    Q_PROPERTY(bool canSuspend READ canSuspend CONSTANT)
    Q_PROPERTY(bool canHibernate READ canHibernate CONSTANT)
    Q_PROPERTY(bool canHybridSleep READ canHybridSleep CONSTANT)
public:
    SessionManager(QObject *parent = Q_NULLPTR);
    virtual ~SessionManager();

    bool registerWithDBus();

    bool isIdle() const;
    void setIdle(bool value);

    bool isLocked() const;

    bool canLock() const;
    bool canStartNewSession();
    bool canLogOut();
    bool canPowerOff();
    bool canRestart();
    bool canSuspend();
    bool canHibernate();
    bool canHybridSleep();

Q_SIGNALS:
    void idleChanged(bool value);
    void lockedChanged(bool value);

    void sessionLocked();
    void sessionUnlocked();

    void loggedOut();

    void idleInhibitRequested();
    void idleUninhibitRequested();

    void logOutRequested();
    void powerOffRequested();
    void restartRequested();
    void suspendRequested();
    void hibernateRequested();
    void hybridSleepRequested();
    void shutdownRequestCanceled();

public Q_SLOTS:
    void autostart();

    void logOut();
    void powerOff();
    void restart();
    void suspend();
    void hibernate();
    void hybridSleep();

    void lockSession();
    void unlockSession(const QString &password, const QJSValue &callback);
    void startNewSession();
    void activateSession(int index);

    void requestLogOut();
    void requestPowerOff();
    void requestRestart();
    void requestSuspend();
    void requestHibernate();
    void requestHybridSleep();
    void cancelShutdownRequest();

private:
    QThread *m_authenticatorThread;
    bool m_authRequested;
    Authenticator *m_authenticator;

    LoginManager *m_loginManager;
    PowerManager *m_powerManager;
    ScreenSaver *m_screenSaver;
    QList<qint64> m_processes;

    bool m_idle;
    bool m_locked;

    void setLocked(bool value);

    friend class CustomAuthenticator;
};

#endif // SESSIONMANAGER_H
