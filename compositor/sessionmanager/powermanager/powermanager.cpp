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

#include <QtDBus/QDBusConnectionInterface>

#include "powermanager.h"
#include "systemdpowerbackend.h"
#include "upowerpowerbackend.h"

PowerManager::PowerManager(QObject *parent)
    : QObject(parent)
{
    QDBusConnectionInterface *interface = QDBusConnection::systemBus().interface();

    if (interface->isServiceRegistered(SystemdPowerBackend::service()))
        m_backends.append(new SystemdPowerBackend());

    if (interface->isServiceRegistered(UPowerPowerBackend::service()))
        m_backends.append(new UPowerPowerBackend());

    connect(interface, &QDBusConnectionInterface::serviceRegistered,
            this, &PowerManager::serviceRegistered);
    connect(interface, &QDBusConnectionInterface::serviceUnregistered,
            this, &PowerManager::serviceUnregistered);
}

PowerManager::~PowerManager()
{
    while (!m_backends.isEmpty())
        m_backends.takeFirst()->deleteLater();
}

PowerManager::Capabilities PowerManager::capabilities() const
{
    PowerManager::Capabilities caps = PowerManager::None;

    foreach (PowerManagerBackend *backend, m_backends)
        caps |= backend->capabilities();

    return caps;
}

void PowerManager::powerOff()
{
    foreach (PowerManagerBackend *backend, m_backends) {
        if (backend->capabilities() & PowerManager::PowerOff) {
            backend->powerOff();
            return;
        }
    }
}

void PowerManager::restart()
{
    foreach (PowerManagerBackend *backend, m_backends) {
        if (backend->capabilities() & PowerManager::Restart) {
            backend->restart();
            return;
        }
    }
}

void PowerManager::suspend()
{
    foreach (PowerManagerBackend *backend, m_backends) {
        if (backend->capabilities() & PowerManager::Suspend) {
            backend->suspend();
            return;
        }
    }
}

void PowerManager::hibernate()
{
    foreach (PowerManagerBackend *backend, m_backends) {
        if (backend->capabilities() & PowerManager::Hibernate) {
            backend->hibernate();
            return;
        }
    }
}

void PowerManager::hybridSleep()
{
    foreach (PowerManagerBackend *backend, m_backends) {
        if (backend->capabilities() & PowerManager::HybridSleep) {
            backend->hybridSleep();
            return;
        }
    }
}

void PowerManager::serviceRegistered(const QString &service)
{
    // Just return if we already have all the backends registered
    if (m_backends.size() == 2)
        return;

    // Otherwise add the most appropriate backend
    if (service == SystemdPowerBackend::service()) {
        m_backends.append(new SystemdPowerBackend());
        Q_EMIT capabilitiesChanged();
    } else if (service == UPowerPowerBackend::service()) {
        m_backends.append(new UPowerPowerBackend());
        Q_EMIT capabilitiesChanged();
    }
}

void PowerManager::serviceUnregistered(const QString &service)
{
    // Just return if we don't have any backend already
    if (m_backends.size() == 0)
        return;

    // Otherwise remove the backend corresponding to the service
    for (int i = 0; i < m_backends.size(); i++) {
        PowerManagerBackend *backend = m_backends.at(i);

        if (service == SystemdPowerBackend::service() && backend->name() == QStringLiteral("systemd")) {
            delete m_backends.takeAt(i);
            Q_EMIT capabilitiesChanged();
            return;
        } else if (service == UPowerPowerBackend::service() && backend->name() == QStringLiteral("upower")) {
            delete m_backends.takeAt(i);
            Q_EMIT capabilitiesChanged();
            return;
        }
    }
}

#include "moc_powermanager.cpp"
