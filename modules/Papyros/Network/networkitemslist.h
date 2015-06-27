/*
    Copyright 2013-2014 Jan Grulich <jgrulich@redhat.com>

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

#ifndef HAWAII_NM_MODEL_NETWORK_ITEMS_LIST_H
#define HAWAII_NM_MODEL_NETWORK_ITEMS_LIST_H

#include <QAbstractListModel>

#include <NetworkManagerQt/ConnectionSettings>

class NetworkModelItem;

class NetworkItemsList : public QObject
{
Q_OBJECT
public:
    enum FilterType {
        ActiveConnection,
        Connection,
        Device,
        Name,
        Nsp,
        Ssid,
        Uuid,
        Type
    };

    explicit NetworkItemsList(QObject* parent = 0);
    virtual ~NetworkItemsList();

    bool contains(const FilterType type, const QString& parameter) const;
    int count() const;
    int indexOf(NetworkModelItem * item) const;
    NetworkModelItem * itemAt(int index) const;
    QList<NetworkModelItem*> items() const;
    QList<NetworkModelItem*> returnItems(const FilterType type, const QString& parameter, const QString& additionalParameter = QString()) const;
    QList<NetworkModelItem*> returnItems(const FilterType type, NetworkManager::ConnectionSettings::ConnectionType typeParameter) const;

    void insertItem(NetworkModelItem * item);
    void removeItem(NetworkModelItem * item);
private:
    QList<NetworkModelItem*> m_items;
};

#endif // HAWAII_NM_MODEL_NETWORK_ITEMS_LIST_H
