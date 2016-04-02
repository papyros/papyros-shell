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

#ifndef POWERMANAGER_H
#define POWERMANAGER_H

#include <QtCore/QObject>

class PowerManagerBackend;

class PowerManager : public QObject
{
    Q_OBJECT
    Q_ENUMS(Capability)
    Q_PROPERTY(Capabilities capabilities READ capabilities NOTIFY capabilitiesChanged)
public:
    enum Capability {
        None = 0x00,
        PowerOff = 0x01,
        Restart = 0x02,
        Suspend = 0x04,
        Hibernate = 0x08,
        HybridSleep = 0x10
    };

    Q_DECLARE_FLAGS(Capabilities, Capability)
    Q_FLAGS(Capabilities)

    explicit PowerManager(QObject *parent = 0);
    ~PowerManager();

    Capabilities capabilities() const;

Q_SIGNALS:
    void capabilitiesChanged();

public Q_SLOTS:
    void powerOff();
    void restart();
    void suspend();
    void hibernate();
    void hybridSleep();

private Q_SLOTS:
    void serviceRegistered(const QString &service);
    void serviceUnregistered(const QString &service);

private:
    Q_DISABLE_COPY(PowerManager)

    QList<PowerManagerBackend *> m_backends;
};

Q_DECLARE_METATYPE(PowerManager *)
Q_DECLARE_OPERATORS_FOR_FLAGS(PowerManager::Capabilities)

#endif // POWERMANAGER_H
