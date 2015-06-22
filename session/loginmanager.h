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

 #ifndef LOGINMANAGER_H
 #define LOGINMANAGER_H

#include <QDBusInterface>
#include <QDBusUnixFileDescriptor>

class LoginManager : public QObject
{
    Q_OBJECT
    Q_ENUMS(InhibitMode)

public:
    LoginManager(QObject *parent = 0);
    ~LoginManager();

    enum InhibitLock {
        InhibitShutdown = 1<<0,
        InhibitSleep = 1<<1,
        InhibitIdle = 1<<2,
        InhibitPowerKey = 1<<3,
        InhibitSuspendKey = 1<<4,
        InhibitHibernateKey = 1<<5,
        InhibitLidSwitch = 1<<6
    };

    enum InhibitMode {
        InhibitBlock = 0,
        InhibitDelay
    };

    Q_DECLARE_FLAGS(InhibitLocks, InhibitLock)

public slots:
    bool canPowerOff();
    bool canRestart();
    bool canSuspend();
    bool canHibernate();

    Q_NOREPLY void powerOff();
    Q_NOREPLY void restart();
    Q_NOREPLY void suspend();
    Q_NOREPLY void hibernate();

    QDBusUnixFileDescriptor inhibit(InhibitLocks locks, const QString &owner, const QString &reason,
            InhibitMode mode);

private:
    QDBusInterface logind;
    QDBusUnixFileDescriptor m_inhibitKeysDescriptor;

    bool canDoAction(const QString &action);
};

Q_DECLARE_OPERATORS_FOR_FLAGS(LoginManager::InhibitLocks)

#endif // LOGINMANAGER_H
