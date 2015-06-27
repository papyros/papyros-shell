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

#ifndef HAWAII_NM_AVAILABLE_DEVICES_H
#define HAWAII_NM_AVAILABLE_DEVICES_H

#include <QObject>

#include <NetworkManagerQt/Device>

class AvailableDevices : public QObject
{
/**
 * Return true when there is present wired device
 */
Q_PROPERTY(bool wiredDeviceAvailable READ isWiredDeviceAvailable NOTIFY wiredDeviceAvailableChanged)
/**
 * Return true when there is present wireless device
 */
Q_PROPERTY(bool wirelessDeviceAvailable READ isWirelessDeviceAvailable NOTIFY wirelessDeviceAvailableChanged)
/**
 * Return true when there is present wimax device
 */
Q_PROPERTY(bool wimaxDeviceAvailable READ isWimaxDeviceAvailable NOTIFY wimaxDeviceAvailableChanged)
/**
 * Return true when there is present modem device
 */
Q_PROPERTY(bool modemDeviceAvailable READ isModemDeviceAvailable NOTIFY modemDeviceAvailableChanged)
/**
 * Return true when there is present bluetooth device
 * Bluetooth device is visible for NetworkManager only when there is some Bluetooth connection
 */
Q_PROPERTY(bool bluetoothDeviceAvailable READ isBluetoothDeviceAvailable NOTIFY bluetoothDeviceAvailableChanged)
Q_OBJECT
public:
    explicit AvailableDevices(QObject* parent = 0);
    virtual ~AvailableDevices();

public Q_SLOTS:
    bool isWiredDeviceAvailable() const;
    bool isWirelessDeviceAvailable() const;
    bool isWimaxDeviceAvailable() const;
    bool isModemDeviceAvailable() const;
    bool isBluetoothDeviceAvailable() const;

private Q_SLOTS:
    void deviceAdded(const QString& dev);
    void deviceRemoved();

Q_SIGNALS:
    void wiredDeviceAvailableChanged(bool available);
    void wirelessDeviceAvailableChanged(bool available);
    void wimaxDeviceAvailableChanged(bool available);
    void modemDeviceAvailableChanged(bool available);
    void bluetoothDeviceAvailableChanged(bool available);

private:
    bool m_wiredDeviceAvailable;
    bool m_wirelessDeviceAvailable;
    bool m_wimaxDeviceAvailable;
    bool m_modemDeviceAvailable;
    bool m_bluetoothDeviceAvailable;
};

#endif // HAWAII_NM_AVAILABLE_DEVICES_H
