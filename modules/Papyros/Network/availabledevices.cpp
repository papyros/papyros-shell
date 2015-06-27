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

#include "availabledevices.h"

#include <NetworkManagerQt/Manager>

AvailableDevices::AvailableDevices(QObject* parent)
    : QObject(parent)
    , m_wiredDeviceAvailable(false)
    , m_wirelessDeviceAvailable(false)
    , m_wimaxDeviceAvailable(false)
    , m_modemDeviceAvailable(false)
    , m_bluetoothDeviceAvailable(false)
{
    Q_FOREACH (const NetworkManager::Device::Ptr& device, NetworkManager::networkInterfaces()) {
        if (device->type() == NetworkManager::Device::Modem) {
            m_modemDeviceAvailable = true;
        } else if (device->type() == NetworkManager::Device::Wifi) {
            m_wirelessDeviceAvailable = true;
        } else if (device->type() == NetworkManager::Device::Wimax) {
            m_wimaxDeviceAvailable = true;
        } else if (device->type() == NetworkManager::Device::Ethernet) {
            m_wiredDeviceAvailable = true;
        } else if (device->type() == NetworkManager::Device::Bluetooth) {
            m_bluetoothDeviceAvailable = true;
        }
    }

    connect(NetworkManager::notifier(), SIGNAL(deviceAdded(QString)),
            SLOT(deviceAdded(QString)));
    connect(NetworkManager::notifier(), SIGNAL(deviceRemoved(QString)),
            SLOT(deviceRemoved()));
}

AvailableDevices::~AvailableDevices()
{
}

bool AvailableDevices::isWiredDeviceAvailable() const
{
    return m_wiredDeviceAvailable;
}

bool AvailableDevices::isWirelessDeviceAvailable() const
{
    return m_wirelessDeviceAvailable;
}

bool AvailableDevices::isWimaxDeviceAvailable() const
{
    return m_wimaxDeviceAvailable;
}

bool AvailableDevices::isModemDeviceAvailable() const
{
    return m_modemDeviceAvailable;
}

bool AvailableDevices::isBluetoothDeviceAvailable() const
{
    return m_bluetoothDeviceAvailable;
}

void AvailableDevices::deviceAdded(const QString& dev)
{
    NetworkManager::Device::Ptr device = NetworkManager::findNetworkInterface(dev);

    if (device) {
        if (device->type() == NetworkManager::Device::Modem && !m_modemDeviceAvailable) {
            m_modemDeviceAvailable = true;
            Q_EMIT modemDeviceAvailableChanged(true);
        } else if (device->type() == NetworkManager::Device::Wifi && !m_wirelessDeviceAvailable) {
            m_wirelessDeviceAvailable = true;
            Q_EMIT wirelessDeviceAvailableChanged(true);
        } else if (device->type() == NetworkManager::Device::Wimax && !m_wimaxDeviceAvailable) {
            m_wimaxDeviceAvailable = true;
            Q_EMIT wimaxDeviceAvailableChanged(true);
        } else if (device->type() == NetworkManager::Device::Ethernet && !m_wiredDeviceAvailable) {
            m_wiredDeviceAvailable = true;
            Q_EMIT wiredDeviceAvailableChanged(true);
        } else if (device->type() == NetworkManager::Device::Bluetooth && !m_bluetoothDeviceAvailable) {
            m_bluetoothDeviceAvailable = true;
            Q_EMIT bluetoothDeviceAvailableChanged(true);
        }
    }
}

void AvailableDevices::deviceRemoved()
{
    bool wired = false;
    bool wireless = false;
    bool wimax = false;
    bool modem = false;
    bool bluetooth = false;

    Q_FOREACH (const NetworkManager::Device::Ptr& device, NetworkManager::networkInterfaces()) {
        if (device->type() == NetworkManager::Device::Modem) {
            modem = true;
        } else if (device->type() == NetworkManager::Device::Wifi) {
            wireless = true;
        } else if (device->type() == NetworkManager::Device::Wimax) {
            wimax = true;
        } else if (device->type() == NetworkManager::Device::Ethernet) {
            wired = true;
        } else if (device->type() == NetworkManager::Device::Bluetooth) {
            bluetooth = true;
        }
    }

    if (!wired && m_wiredDeviceAvailable) {
        m_wiredDeviceAvailable = false;
        Q_EMIT wiredDeviceAvailableChanged(false);
    }

    if (!wireless && m_wirelessDeviceAvailable) {
        m_wirelessDeviceAvailable = false;
        Q_EMIT wirelessDeviceAvailableChanged(false);
    }

    if (!wimax && m_wimaxDeviceAvailable) {
        m_wimaxDeviceAvailable = false;
        Q_EMIT wimaxDeviceAvailableChanged(false);
    }

    if (!modem && m_modemDeviceAvailable) {
        m_modemDeviceAvailable = false;
        Q_EMIT modemDeviceAvailableChanged(false);
    }

    if (!bluetooth && m_bluetoothDeviceAvailable) {
        m_bluetoothDeviceAvailable = false;
        Q_EMIT bluetoothDeviceAvailableChanged(false);
    }
}
