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

#ifndef BATTERY_H
#define BATTERY_H

#include <QtCore/QObject>
#include <QtCore/QLoggingCategory>

#include <Solid/Device>
#include <Solid/Battery>

Q_DECLARE_LOGGING_CATEGORY(BATTERY)

class Battery : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString udi READ udi CONSTANT)
    Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(QString iconName READ iconName CONSTANT)
    Q_PROPERTY(Type type READ type CONSTANT)
    Q_PROPERTY(Technology technology READ technology CONSTANT)
    Q_PROPERTY(int chargePercent READ chargePercent NOTIFY chargePercentChanged)
    Q_PROPERTY(int capacity READ capacity NOTIFY capacityChanged)
    Q_PROPERTY(bool rechargeable READ isRechargeable CONSTANT)
    Q_PROPERTY(bool powerSupply READ isPowerSupply NOTIFY powerSupplyChanged)
    Q_PROPERTY(ChargeState chargeState READ chargeState NOTIFY chargeStateChanged)
    Q_PROPERTY(qlonglong timeToEmpty READ timeToEmpty NOTIFY timeToEmptyChanged)
    Q_PROPERTY(qlonglong timeToFull READ timeToFull NOTIFY timeToFullChanged)
    Q_PROPERTY(double energy READ energy NOTIFY energyChanged)
    Q_PROPERTY(double energyRate READ energyRate NOTIFY energyRateChanged)
    Q_PROPERTY(double voltage READ voltage NOTIFY voltageChanged)
    Q_PROPERTY(double temperature READ temperature NOTIFY temperatureChanged)
    Q_PROPERTY(bool recalled READ isRecalled CONSTANT)
    Q_PROPERTY(QString recallVendor READ recallVendor CONSTANT)
    Q_PROPERTY(QUrl recallUrl READ recallUrl CONSTANT)
    Q_PROPERTY(QString vendor READ vendor CONSTANT)
    Q_PROPERTY(QString product READ product CONSTANT)
    Q_PROPERTY(QString serial READ serial CONSTANT)
    Q_ENUMS(Type Technology ChargeState)
public:
    enum Type {
        UnknownBattery,
        PdaBattery,
        UpsBattery,
        PrimaryBattery,
        MouseBattery,
        KeyboardBattery,
        KeyboardMouseBattery,
        CameraBattery,
        PhoneBattery,
        MonitorBattery
    };

    enum Technology {
        UnknownTechnology,
        LithiumIon,
        LithiumPolymer,
        LithiumIronPhosphate,
        LeadAcid,
        NickelCadmium,
        NickelMetalHydride
    };

    enum ChargeState {
        Stable,
        Charging,
        Discharging,
        FullyCharged
    };

    Battery(const QString &udi, QObject *parent = 0);
    ~Battery();

    QString udi() const;
    QString name() const;
    QString iconName() const;

    Type type() const;
    Technology technology() const;

    int chargePercent() const;
    int capacity() const;
    bool isRechargeable() const;
    bool isPowerSupply() const;
    ChargeState chargeState() const;

    qlonglong timeToEmpty() const;
    qlonglong timeToFull() const;

    double energy() const;
    double energyRate() const;

    double voltage() const;

    double temperature() const;

    bool isRecalled() const;
    QString recallVendor() const;
    QUrl recallUrl() const;

    QString vendor() const;
    QString product() const;

    QString serial() const;

Q_SIGNALS:
    void chargePercentChanged();
    void capacityChanged();
    void powerSupplyChanged();
    void chargeStateChanged();
    void timeToEmptyChanged();
    void timeToFullChanged();
    void energyChanged();
    void energyRateChanged();
    void voltageChanged();
    void temperatureChanged();

private:
    Solid::Device m_device;
    Solid::Battery *m_battery;
};

#endif // BATTERY_H
