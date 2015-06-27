/*
    Copyright 2010 Sebastian Kügler <sebas@kde.org>
    Copyright 2010-2013 Lamarque V. Souza <lamarque@kde.org>
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

#ifndef HAWAII_NM_TRAFFIC_MONITOR_H
#define HAWAII_NM_TRAFFIC_MONITOR_H

#include <QGraphicsWidget>

#include <NetworkManagerQt/Device>
#include <NetworkManagerQt/ModemDevice>

#include <Plasma/DataEngine>
#include <Plasma/SignalPlotter>
#include <Plasma/Label>

class TrafficMonitor : public QGraphicsWidget
{
Q_PROPERTY(QString device READ device WRITE setDevice)
Q_PROPERTY(qreal height READ height NOTIFY heightChanged)
Q_OBJECT
public:
    explicit TrafficMonitor(QGraphicsItem * parent = 0);
    virtual ~TrafficMonitor();

    void setDevice(const QString & device);
    QString device() const;

    qreal height() const;

public Q_SLOTS:
    void dataUpdated(const QString & sourceName, const Plasma::DataEngine::Data & data);

private:
    void resetMonitor();
    void updateTraffic();
    void setUpdateEnabled(bool enable);

    NetworkManager::Device::Ptr m_device;

    Plasma::DataEngine * m_engine;
    Plasma::SignalPlotter *m_trafficPlotter;
    Plasma::Label * m_traffic;

    QString m_tx;
    QString m_txSource;
    QString m_txTotalSource;
    QString m_txUnit;
    QString m_rx;
    QString m_rxSource;
    QString m_rxTotalSource;
    QString m_rxUnit;
    QColor m_txColor;
    QColor m_rxColor;
    qlonglong m_txTotal;
    qlonglong m_rxTotal;

    bool m_updateEnabled;
    int m_speedUnit;

Q_SIGNALS:
    void heightChanged();
};

#endif // HAWAII_NM_TRAFFIC_MONITOR_H
