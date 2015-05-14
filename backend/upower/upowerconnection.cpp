/*
 * QML Desktop - Set of tools written in C++ for QML
 * 
 * Copyright (C) 2014 Bogdan Cuza <bogdan.cuza@hotmail.com>
 *               2015 Michael Spencer <sonrisesoftware@gmail.com>
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

#include "upowerconnection.h"

UPowerConnection::UPowerConnection(QQuickItem *parent)
        : QQuickItem(parent),
          iface("org.freedesktop.UPower", "/org/freedesktop/UPower",
                "org.freedesktop.UPower", QDBusConnection::systemBus())
{
    QDBusConnection::systemBus().connect(iface.service(), iface.path(), iface.interface(),
            "DeviceAdded", this, SLOT(reloadDevices()));
    QDBusConnection::systemBus().connect(iface.service(), iface.path(), iface.interface(),
            "DeviceRemoved", this, SLOT(reloadDevices()));
    QDBusConnection::systemBus().connect(iface.service(), iface.path(), iface.interface(),
            "DeviceChanged", this, SLOT(reloadDevices()));

    reloadDevices();
}

void UPowerConnection::reloadDevices()
{

    QDBusMessage msg = iface.call("EnumerateDevices");
    const QDBusArgument &arg = msg.arguments().at(0).value<QDBusArgument>();
    deviceList.clear();

    arg.beginArray();
    while (!arg.atEnd()) {
        QDBusObjectPath path;
        arg >> path;
        UPowerDevice *device =  new UPowerDevice(path.path());
        deviceList << device;
    }
    arg.endArray();

    emit devicesChanged();
}
