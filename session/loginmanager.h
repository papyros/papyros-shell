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

class LoginManager : public QObject
{
    Q_OBJECT

public:
    LoginManager(QObject *parent = 0);

public slots:
    bool canPowerOff();
    bool canRestart();
    bool canSuspend();
    bool canHibernate();

    Q_NOREPLY void powerOff();
    Q_NOREPLY void restart();
    Q_NOREPLY void suspend();
    Q_NOREPLY void hibernate();

private:
    QDBusInterface logind;

    bool canDoAction(const QString &action);
};

#endif // LOGINMANAGER_H
