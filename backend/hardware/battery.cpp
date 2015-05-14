/****************************************************************************
* This file is part of Hawaii.
 *
 * Copyright (C) 2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * Author(s):
 *    Pier Luigi Fiorini
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

#include <QtCore/QUrl>

#include "battery.h"

Q_LOGGING_CATEGORY(BATTERY, "hawaii.qml.hardware.battery")

Battery::Battery(const QString &udi, QObject *parent)
    : QObject(parent)
    , m_device(Solid::Device(udi))
{
    qCDebug(BATTERY) << "Added battery" << udi;

    m_battery = m_device.as<Solid::Battery>();
    connect(m_battery, &Solid::Battery::chargePercentChanged, [this](int, const QString &) {
        Q_EMIT chargePercentChanged();
    });
    connect(m_battery, &Solid::Battery::capacityChanged, [this](int, const QString &) {
        Q_EMIT capacityChanged();
    });
    connect(m_battery, &Solid::Battery::powerSupplyStateChanged, [this](bool, const QString &) {
        Q_EMIT powerSupplyChanged();
    });
    connect(m_battery, &Solid::Battery::chargeStateChanged, [this](int, const QString &) {
        Q_EMIT chargeStateChanged();
    });
    connect(m_battery, &Solid::Battery::timeToEmptyChanged, [this](qlonglong, const QString &) {
        Q_EMIT timeToEmptyChanged();
    });
    connect(m_battery, &Solid::Battery::timeToFullChanged, [this](qlonglong, const QString &) {
        Q_EMIT timeToFullChanged();
    });
    connect(m_battery, &Solid::Battery::chargeStateChanged, [this](int, const QString &) {
        Q_EMIT chargeStateChanged();
    });
    connect(m_battery, &Solid::Battery::energyChanged, [this](double, const QString &) {
        Q_EMIT energyChanged();
    });
    connect(m_battery, &Solid::Battery::energyRateChanged, [this](double, const QString &) {
        Q_EMIT energyRateChanged();
    });
    connect(m_battery, &Solid::Battery::voltageChanged, [this](double, const QString &) {
        Q_EMIT voltageChanged();
    });
    connect(m_battery, &Solid::Battery::temperatureChanged, [this](double, const QString &) {
        Q_EMIT temperatureChanged();
    });
}

Battery::~Battery()
{
    qCDebug(BATTERY) << "Removed battery" << m_device.udi();
}

QString Battery::udi() const
{
    return m_device.udi();
}

QString Battery::name() const
{
    return m_device.description();
}

QString Battery::iconName() const
{
    return m_device.icon();
}

Battery::Type Battery::type() const
{
    return static_cast<Battery::Type>(m_battery->type());
}

Battery::Technology Battery::technology() const
{
    return static_cast<Battery::Technology>(m_battery->technology());
}

int Battery::chargePercent() const
{
    return m_battery->chargePercent();
}

int Battery::capacity() const
{
    return m_battery->capacity();
}

bool Battery::isRechargeable() const
{
    return m_battery->isRechargeable();
}

bool Battery::isPowerSupply() const
{
    return m_battery->isPowerSupply();
}

Battery::ChargeState Battery::chargeState() const
{
    return static_cast<Battery::ChargeState>(m_battery->chargeState());
}

qlonglong Battery::timeToEmpty() const
{
    return m_battery->timeToEmpty();
}

qlonglong Battery::timeToFull() const
{
    return m_battery->timeToFull();
}

double Battery::energy() const
{
    return m_battery->energy();
}

double Battery::energyRate() const
{
    return m_battery->energyRate();
}

double Battery::voltage() const
{
    return m_battery->voltage();
}

double Battery::temperature() const
{
    return m_battery->temperature();
}

bool Battery::isRecalled() const
{
    return m_battery->isRecalled();
}

QString Battery::recallVendor() const
{
    return m_battery->recallVendor();
}

QUrl Battery::recallUrl() const
{
    return QUrl(m_battery->recallUrl());
}

QString Battery::vendor() const
{
    return m_device.vendor();
}

QString Battery::product() const
{
    return m_device.product();
}

QString Battery::serial() const
{
    return m_battery->serial();
}

#include "moc_battery.cpp"
