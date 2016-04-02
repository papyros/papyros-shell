/****************************************************************************
 * This file is part of Hawaii Shell.
 *
 * Copyright (C) 2013-2016 Pier Luigi Fiorini
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

#include <QtDBus/QDBusReply>

#include "systemdpowerbackend.h"

#define LOGIN1_SERVICE QStringLiteral("org.freedesktop.login1")
#define LOGIN1_PATH QStringLiteral("/org/freedesktop/login1")
#define LOGIN1_OBJECT QStringLiteral("org.freedesktop.login1.Manager")

QString SystemdPowerBackend::service()
{
    return LOGIN1_SERVICE;
}

SystemdPowerBackend::SystemdPowerBackend()
{
    m_interface = new QDBusInterface(LOGIN1_SERVICE, LOGIN1_PATH,
                                     LOGIN1_OBJECT, QDBusConnection::systemBus());
}

SystemdPowerBackend::~SystemdPowerBackend()
{
    m_interface->deleteLater();
}

QString SystemdPowerBackend::name() const
{
    return QStringLiteral("systemd");
}

PowerManager::Capabilities SystemdPowerBackend::capabilities() const
{
    PowerManager::Capabilities caps = PowerManager::None;

    QStringList validValues;
    validValues << QStringLiteral("yes") << QStringLiteral("challenge");

    QDBusReply<QString> reply;

    reply = m_interface->call(QStringLiteral("CanPowerOff"));
    if (reply.isValid() && validValues.contains(reply.value()))
        caps |= PowerManager::PowerOff;

    reply = m_interface->call(QStringLiteral("CanReboot"));
    if (reply.isValid() && validValues.contains(reply.value()))
        caps |= PowerManager::Restart;

    reply = m_interface->call(QStringLiteral("CanSuspend"));
    if (reply.isValid() && validValues.contains(reply.value()))
        caps |= PowerManager::Suspend;

    reply = m_interface->call(QStringLiteral("CanHibernate"));
    if (reply.isValid() && validValues.contains(reply.value()))
        caps |= PowerManager::Hibernate;

    reply = m_interface->call(QStringLiteral("CanHybridSleep"));
    if (reply.isValid() && validValues.contains(reply.value()))
        caps |= PowerManager::HybridSleep;

    return caps;
}

void SystemdPowerBackend::powerOff()
{
    m_interface->call(QStringLiteral("PowerOff"), true);
}

void SystemdPowerBackend::restart()
{
    m_interface->call(QStringLiteral("Reboot"), true);
}

void SystemdPowerBackend::suspend()
{
    m_interface->call(QStringLiteral("Suspend"), true);
}

void SystemdPowerBackend::hibernate()
{
    m_interface->call(QStringLiteral("Hibernate"), true);
}

void SystemdPowerBackend::hybridSleep()
{
    m_interface->call(QStringLiteral("HybridSleep"), true);
}
