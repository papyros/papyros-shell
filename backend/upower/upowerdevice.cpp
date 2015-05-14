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

#include "upowerdevice.h"


UPowerDevice::UPowerDevice(QString path, QObject *parent)
        : QObject(parent),
          iface("org.freedesktop.UPower", path, "org.freedesktop.UPower.Device", QDBusConnection::systemBus())
{
    QDBusConnection::systemBus().connect(iface.service(), iface.path(),
            "org.freedesktop.DBus.Properties", "PropertiesChanged",
            this, SLOT(reload()));

    reload();
}

void UPowerDevice::reload()
{

    m_vendor = iface.property("Vendor");

    m_type = static_cast<UPowerDeviceType::Type>(iface.property("Type").toInt());

    if (m_type == UPowerDeviceType::LinePower) {
        m_online = iface.property("Online");
    } else if (m_type == UPowerDeviceType::Battery || m_type == UPowerDeviceType::Mouse
               || m_type == UPowerDeviceType::Keyboard) {
        m_energy = iface.property("Energy");
        m_energyFull = iface.property("EnergyFull");
        m_energyEmpty = iface.property("EnergyEmpty");
        m_energyRate = iface.property("EnergyRate");
        m_timeToEmpty = iface.property("TimeToEmpty");
        m_timeToFull = iface.property("TimeToFull");
        m_percentage = iface.property("Percentage");
        m_state = iface.property("State");
        m_isRechargeable = iface.property("IsRechargeable");
        m_capacity = iface.property("Capacity");
    }

    m_voltage = iface.property("Voltage").toBool();
    m_powerSupply = iface.property("PowerSupply").toBool();

    emit changed();
}
