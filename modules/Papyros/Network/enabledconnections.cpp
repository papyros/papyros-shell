/*
    Copyright 2013 Jan Grulich <jgrulich@redhat.com>

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) version 3, or any
    later version accepted by the membership of KDE e.V. (or its
    successor approved by the membership of KDE e.V.), which shall
    act as a proxy defined in Section 6 of version 3 of the license.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library.  If not, see <http://www.gnu.org/licenses/>.
*/


#include "enabledconnections.h"

#include <NetworkManagerQt/Manager>

EnabledConnections::EnabledConnections(QObject* parent)
    : QObject(parent)
    , m_networkingEnabled(NetworkManager::isNetworkingEnabled())
    , m_wirelessEnabled(NetworkManager::isWirelessEnabled())
    , m_wirelessHwEnabled(NetworkManager::isWirelessHardwareEnabled())
    , m_wimaxEnabled(NetworkManager::isWimaxEnabled())
    , m_wimaxHwEnabled(NetworkManager::isWimaxHardwareEnabled())
    , m_wwanEnabled(NetworkManager::isWwanEnabled())
    , m_wwanHwEnabled(NetworkManager::isWwanHardwareEnabled())
{
    connect(NetworkManager::notifier(), SIGNAL(networkingEnabledChanged(bool)),
            SLOT(onNetworkingEnabled(bool)));
    connect(NetworkManager::notifier(), SIGNAL(wirelessEnabledChanged(bool)),
            SLOT(onWirelessEnabled(bool)));
    connect(NetworkManager::notifier(), SIGNAL(wirelessHardwareEnabledChanged(bool)),
            SLOT(onWirelessHwEnabled(bool)));
    connect(NetworkManager::notifier(), SIGNAL(wimaxEnabledChanged(bool)),
            SLOT(onWimaxEnabled(bool)));
    connect(NetworkManager::notifier(), SIGNAL(wimaxHardwareEnabledChanged(bool)),
            SLOT(onWimaxHwEnabled(bool)));
    connect(NetworkManager::notifier(), SIGNAL(wwanEnabledChanged(bool)),
            SLOT(onWwanEnabled(bool)));
    connect(NetworkManager::notifier(), SIGNAL(wwanHardwareEnabledChanged(bool)),
            SLOT(onWwanHwEnabled(bool)));
}

EnabledConnections::~EnabledConnections()
{
}

bool EnabledConnections::isNetworkingEnabled() const
{
    return m_networkingEnabled;
}

bool EnabledConnections::isWirelessEnabled() const
{
    return m_wirelessEnabled;
}

bool EnabledConnections::isWirelessHwEnabled() const
{
    return m_wirelessHwEnabled;
}

bool EnabledConnections::isWimaxEnabled() const
{
    return m_wimaxEnabled;
}

bool EnabledConnections::isWimaxHwEnabled() const
{
    return m_wimaxHwEnabled;
}

bool EnabledConnections::isWwanEnabled() const
{
    return m_wwanEnabled;
}

bool EnabledConnections::isWwanHwEnabled() const
{
    return m_wwanHwEnabled;
}

void EnabledConnections::onNetworkingEnabled(bool enabled)
{
    m_networkingEnabled = enabled;
    Q_EMIT networkingEnabled(enabled);
}

void EnabledConnections::onWirelessEnabled(bool enabled)
{
    m_wirelessEnabled = enabled;
    Q_EMIT wirelessEnabled(enabled);
}

void EnabledConnections::onWirelessHwEnabled(bool enabled)
{
    m_wirelessHwEnabled = enabled;
    Q_EMIT wirelessHwEnabled(enabled);
}

void EnabledConnections::onWimaxEnabled(bool enabled)
{
    m_wimaxEnabled = enabled;
    Q_EMIT wimaxEnabled(enabled);
}

void EnabledConnections::onWimaxHwEnabled(bool enabled)
{
    m_wimaxHwEnabled = enabled;
    Q_EMIT wimaxHwEnabled(enabled);
}

void EnabledConnections::onWwanEnabled(bool enabled)
{
    m_wwanEnabled = enabled;
    Q_EMIT wwanEnabled(enabled);
}

void EnabledConnections::onWwanHwEnabled(bool enabled)
{
    m_wwanHwEnabled = enabled;
    Q_EMIT wwanHwEnabled(enabled);
}
