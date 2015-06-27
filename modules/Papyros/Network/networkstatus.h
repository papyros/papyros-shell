/*
    Copyright 2013 Jan Grulich <jgrulich@redhat.com>
    Copyright 2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>

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

#ifndef HAWAII_NM_NETWORK_STATUS_H
#define HAWAII_NM_NETWORK_STATUS_H

#include <QObject>

#include <NetworkManagerQt/Manager>

class NetworkStatus : public QObject
{
/**
 * Returns a formated list of active connections or NM status when there is no active connection
 */
Q_PROPERTY(QString activeConnections READ activeConnections NOTIFY activeConnectionsChanged)
/**
 * Returns the current status of NetworkManager
 */
Q_PROPERTY(QString networkStatus READ networkStatus NOTIFY networkStatusChanged)
Q_OBJECT
public:
    explicit NetworkStatus(QObject* parent = 0);
    virtual ~NetworkStatus();

    QString activeConnections() const;
    QString networkStatus() const;

private Q_SLOTS:
    void activeConnectionsChanged();
    void defaultChanged();
    void statusChanged(NetworkManager::Status status);
    void changeActiveConnections();

Q_SIGNALS:
    void activeConnectionsChanged(const QString & activeConnections);
    void networkStatusChanged(const QString & status);

private:
    QString m_activeConnections;
    QString m_networkStatus;

    QString checkUnknownReason() const;
};

#endif // PLAMA_NM_NETWORK_STATUS_H
