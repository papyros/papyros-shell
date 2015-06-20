/****************************************************************************
* This file is part of Hawaii.
 *
 * Copyright (C) 2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *               2015 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * Author(s):
 *    Pier Luigi Fiorini
 *    Michael Spencer
 *
 * $BEGIN_LICENSE:LGPL2.1+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

#include <Solid/DeviceNotifier>
#include <Solid/StorageAccess>

#include "hardwareengine.h"

Q_LOGGING_CATEGORY(HARDWARE, "hawaii.qml.hardware")

HardwareEngine::HardwareEngine(QObject *parent)
    : QObject(parent)
{
    // Populate list as devices come and go
    Solid::DeviceNotifier *notifier = Solid::DeviceNotifier::instance();
    connect(notifier, &Solid::DeviceNotifier::deviceAdded, [this](const QString &udi) {
        Solid::Device device(udi);
        if (device.as<Solid::Battery>()) {
            Battery *battery = new Battery(device.udi());
            m_batteries[device.udi()] = battery;
            Q_EMIT batteriesChanged();
            Q_EMIT batteryAdded(battery);
        } else if (device.as<Solid::StorageAccess>()) {
            StorageDevice *storageDevice = new StorageDevice(device.udi());
            m_storageDevices[device.udi()] = storageDevice;
            Q_EMIT storageDevicesChanged();
            Q_EMIT storageDeviceAdded(storageDevice);
        }
    });
    connect(notifier, &Solid::DeviceNotifier::deviceRemoved, [this](const QString &udi) {
        Battery *battery = m_batteries.value(udi, Q_NULLPTR);
        if (battery) {
            m_batteries.remove(udi);
            Q_EMIT batteriesChanged();
            Q_EMIT batteryRemoved(battery);
            battery->deleteLater();
            return;
        }

        StorageDevice *storageDevice = m_storageDevices.value(udi, Q_NULLPTR);
        if (storageDevice) {
            m_storageDevices.remove(udi);
            Q_EMIT storageDevicesChanged();
            Q_EMIT storageDeviceRemoved(storageDevice);
            storageDevice->deleteLater();
            return;
        }
    });

    // Add already existing devices
    qCDebug(HARDWARE) << "Populate initial devices list";
    for (const Solid::Device &device: Solid::Device::allDevices()) {
        if (device.as<Solid::Battery>()) {
            Battery *battery = new Battery(device.udi());
            m_batteries[device.udi()] = battery;
            Q_EMIT batteriesChanged();
            Q_EMIT batteryAdded(battery);
        } else if (device.as<Solid::StorageAccess>()) {
            StorageDevice *storageDevice = new StorageDevice(device.udi());
            m_storageDevices[device.udi()] = storageDevice;
            Q_EMIT storageDevicesChanged();
            Q_EMIT storageDeviceAdded(storageDevice);
        }
    }
}

HardwareEngine::~HardwareEngine()
{
    qDeleteAll(m_storageDevices);
    m_storageDevices.clear();
}

Battery *HardwareEngine::primaryBattery() const
{
    Q_FOREACH(Battery *battery, m_batteries) {
        if (battery->type() == Battery::PrimaryBattery)
            return battery;
    }

    return nullptr;
}

QQmlListProperty<Battery> HardwareEngine::batteries()
{
    auto countFunc = [](QQmlListProperty<Battery> *prop) {
        return static_cast<HardwareEngine *>(prop->object)->m_batteries.count();
    };
    auto atFunc = [](QQmlListProperty<Battery> *prop, int index) {
        return static_cast<HardwareEngine *>(prop->object)->m_batteries.values().at(index);
    };
    return QQmlListProperty<Battery>(this, 0, countFunc, atFunc);
}

QQmlListProperty<StorageDevice> HardwareEngine::storageDevices()
{
    auto countFunc = [](QQmlListProperty<StorageDevice> *prop) {
        return static_cast<HardwareEngine *>(prop->object)->m_storageDevices.count();
    };
    auto atFunc = [](QQmlListProperty<StorageDevice> *prop, int index) {
        return static_cast<HardwareEngine *>(prop->object)->m_storageDevices.values().at(index);
    };
    return QQmlListProperty<StorageDevice>(this, 0, countFunc, atFunc);
}

#include "moc_hardwareengine.cpp"
