/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 * Copyright (C) 2015 Michael Spencer <sonrisesoftware@gmail.com>
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

 #ifndef SESSIONADAPTOR_H
 #define SESSIONADAPTOR_H

#include <QDBusAbstractAdaptor>

#include "loginmanager.h"
#include "sessionmanager.h"

class SessionAdaptor : public QDBusAbstractAdaptor
{

    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "io.papyros.Session")
    Q_PROPERTY(bool locked READ isLocked NOTIFY lockedChanged)

public:
    SessionAdaptor(SessionManager *sessionManager);

    bool isLocked() const;

signals:
    void idleChanged();
    void lockedChanged();
    void sessionLocked();
    void sessionUnlocked();

public slots:
    bool canLock();
    bool canStartNewSession();
    bool canLogOut();
    bool canPowerOff();
    bool canRestart();
    bool canSuspend();
    bool canHibernate();

    Q_NOREPLY void lockSession();
    Q_NOREPLY void unlockSession();

    Q_NOREPLY void startNewSession();

    Q_NOREPLY void activateSession(int index);

    Q_NOREPLY void logOut();
    Q_NOREPLY void powerOff();
    Q_NOREPLY void restart();
    Q_NOREPLY void suspend();
    Q_NOREPLY void hibernate();

private:
    SessionManager *m_sessionManager;
    LoginManager *m_loginManager;
};

#endif // SESSIONADAPTOR_H
