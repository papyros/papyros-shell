/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 *
 * Copyright (C) 2015 Michael Spencer <sonrisesoftware@gmail.com>
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

#include "loginmanager.h"

#include <QDBusReply>

LoginManager::LoginManager(QObject *parent)
        : QObject(parent)
        , logind("org.freedesktop.login1", "/org/freedesktop/login1",
          "org.freedesktop.login1.Manager", QDBusConnection::systemBus())
{
    // Nothing needed here
}

bool LoginManager::canDoAction(const QString &action)
{
    QStringList validValues;
    validValues << QStringLiteral("yes") << QStringLiteral("challenge");

    QDBusReply<QString> reply;

    reply = logind.call(QStringLiteral("Can%1").arg(action));
    return reply.isValid() && validValues.contains(reply.value());
}

bool LoginManager::canPowerOff()
{
    return canDoAction("PowerOff");
}

bool LoginManager::canRestart()
{
    return canDoAction("Reboot");
}

bool LoginManager::canSuspend()
{
    return canDoAction("Suspend");
}

bool LoginManager::canHibernate()
{
    return canDoAction("Hibernate");
}

void LoginManager::restart()
{
    logind.call("Reboot", true);
}

void LoginManager::powerOff()
{
    logind.call("PowerOff", true);
}

void LoginManager::suspend()
{
    logind.call("Reboot", true);
}

void LoginManager::hibernate()
{
    logind.call("PowerOff", true);
}
