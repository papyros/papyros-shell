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

#ifndef UPOWERDEVICE
#define UPOWERDEVICE

#include <QObject>
#include <QDBusInterface>
#include "upowerdevicetype.h"

class UPowerDevice : public QObject
{
    Q_OBJECT

    // We're using variants not because I am lazy, but because they will return an undefined
    // and it will be idiomatic JavaScript
    Q_PROPERTY(UPowerDeviceType::Type type MEMBER m_type CONSTANT)
    Q_PROPERTY(bool powerSupply MEMBER m_powerSupply CONSTANT)
    Q_PROPERTY(QVariant online MEMBER m_online CONSTANT)
    Q_PROPERTY(QVariant energy MEMBER m_energy NOTIFY changed)
    Q_PROPERTY(QVariant energyFull MEMBER m_energyFull CONSTANT)
    Q_PROPERTY(QVariant energyEmpty MEMBER m_energyEmpty CONSTANT)
    Q_PROPERTY(double voltage MEMBER m_voltage NOTIFY changed)
    Q_PROPERTY(QVariant energyRate MEMBER m_energyRate NOTIFY changed)
    Q_PROPERTY(QVariant timeToEmpty MEMBER m_timeToEmpty NOTIFY changed)
    Q_PROPERTY(QVariant timeToFull MEMBER m_timeToFull NOTIFY changed)
    Q_PROPERTY(QVariant percentage MEMBER m_percentage NOTIFY changed)
    Q_PROPERTY(QVariant state MEMBER m_state NOTIFY changed)
    Q_PROPERTY(QVariant isRechargeable MEMBER m_isRechargeable CONSTANT)
    Q_PROPERTY(QVariant capacity MEMBER m_capacity CONSTANT)
    Q_PROPERTY(QVariant vendor MEMBER m_vendor CONSTANT)

public:
    explicit UPowerDevice(QString path, QObject *parent = 0);

    UPowerDeviceType::Type m_type;
    bool m_powerSupply;
    QVariant m_online;
    QVariant m_energy;
    QVariant m_energyEmpty;
    QVariant m_energyFull;
    double m_voltage;
    QVariant m_energyRate;
    QVariant m_timeToEmpty;
    QVariant m_timeToFull;
    QVariant m_percentage;
    QVariant m_state;
    QVariant m_isRechargeable;
    QVariant m_capacity;
    QVariant m_vendor;

signals:
    void changed();

private slots:

    void reload();

private:
    QDBusInterface iface;
};

#endif // UPOWERDEVICE
