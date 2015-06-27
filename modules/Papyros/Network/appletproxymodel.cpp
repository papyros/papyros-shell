/*
    Copyright 2013-2014 Jan Grulich <jgrulich@redhat.com>
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

#include "appletproxymodel.h"
#include "networkmodel.h"

AppletProxyModel::SortedConnectionType AppletProxyModel::connectionTypeToSortedType(NetworkManager::ConnectionSettings::ConnectionType type)
{
    switch (type) {
        case NetworkManager::ConnectionSettings::Unknown:
            return AppletProxyModel::AppletProxyModel::Unknown;
            break;
        case NetworkManager::ConnectionSettings::Adsl:
            return AppletProxyModel::AppletProxyModel::Adsl;
            break;
        case NetworkManager::ConnectionSettings::Bluetooth:
            return AppletProxyModel::Bluetooth;
            break;
        case NetworkManager::ConnectionSettings::Bond:
            return AppletProxyModel::Bond;
            break;
        case NetworkManager::ConnectionSettings::Bridge:
            return AppletProxyModel::Bridge;
            break;
        case NetworkManager::ConnectionSettings::Cdma:
            return AppletProxyModel::Cdma;
            break;
        case NetworkManager::ConnectionSettings::Gsm:
            return AppletProxyModel::Gsm;
            break;
        case NetworkManager::ConnectionSettings::Infiniband:
            return AppletProxyModel::Infiniband;
            break;
        case NetworkManager::ConnectionSettings::OLPCMesh:
            return AppletProxyModel::OLPCMesh;
            break;
        case NetworkManager::ConnectionSettings::Pppoe:
            return AppletProxyModel::Pppoe;
            break;
#if NM_CHECK_VERSION(0, 9, 10)
        case NetworkManager::ConnectionSettings::Team:
            return AppletProxyModel::Team;
            break;
#endif
        case NetworkManager::ConnectionSettings::Vlan:
            return AppletProxyModel::Vlan;
            break;
        case NetworkManager::ConnectionSettings::Vpn:
            return AppletProxyModel::Vpn;
            break;
        case NetworkManager::ConnectionSettings::Wimax:
            return AppletProxyModel::Wimax;
            break;
        case NetworkManager::ConnectionSettings::Wired:
            return AppletProxyModel::Wired;
            break;
        case NetworkManager::ConnectionSettings::Wireless:
            return AppletProxyModel::Wireless;
            break;
        default:
            return AppletProxyModel::Unknown;
            break;
    }
}

AppletProxyModel::AppletProxyModel(QObject* parent)
    : QSortFilterProxyModel(parent)
{
    setDynamicSortFilter(true);
    sort(0, Qt::DescendingOrder);
    setSourceModel(new NetworkModel);
}

AppletProxyModel::~AppletProxyModel()
{
}

bool AppletProxyModel::filterAcceptsRow(int source_row, const QModelIndex& source_parent) const
{
    const QModelIndex index = sourceModel()->index(source_row, 0, source_parent);

    // slaves are always filtered-out
    const bool isSlave = sourceModel()->data(index, NetworkModel::SlaveRole).toBool();
    if (isSlave) {
        return false;
    }

#if NM_CHECK_VERSION(0, 9, 10)
    const NetworkManager::ConnectionSettings::ConnectionType type = (NetworkManager::ConnectionSettings::ConnectionType) sourceModel()->data(index, NetworkModel::TypeRole).toUInt();
    if (type == NetworkManager::ConnectionSettings::Generic) {
        return false;
    }
#endif

    NetworkModelItem::ItemType itemType = (NetworkModelItem::ItemType)sourceModel()->data(index, NetworkModel::ItemTypeRole).toUInt();

    if (itemType == NetworkModelItem::AvailableConnection ||
        itemType == NetworkModelItem::AvailableAccessPoint ||
        itemType == NetworkModelItem::AvailableNsp) {
        return true;
    }

    return false;
}

bool AppletProxyModel::lessThan(const QModelIndex& left, const QModelIndex& right) const
{
    const bool leftAvailable = (NetworkModelItem::ItemType)sourceModel()->data(left, NetworkModel::ItemTypeRole).toUInt() != NetworkModelItem::UnavailableConnection;
    const bool leftConnected = sourceModel()->data(left, NetworkModel::ConnectionStateRole).toUInt() == NetworkManager::ActiveConnection::Activated;
    const int leftConnectionState = sourceModel()->data(left, NetworkModel::ConnectionStateRole).toUInt();
    const QString leftName = sourceModel()->data(left, NetworkModel::NameRole).toString();
    const SortedConnectionType leftType = connectionTypeToSortedType((NetworkManager::ConnectionSettings::ConnectionType) sourceModel()->data(left, NetworkModel::TypeRole).toUInt());
    const QString leftUuid = sourceModel()->data(left, NetworkModel::UuidRole).toString();
    const int leftSignal = sourceModel()->data(left, NetworkModel::SignalRole).toInt();
    const QDateTime leftDate = sourceModel()->data(left, NetworkModel::TimeStampRole).toDateTime();

    const bool rightAvailable = (NetworkModelItem::ItemType)sourceModel()->data(right, NetworkModel::ItemTypeRole).toUInt() != NetworkModelItem::UnavailableConnection;
    const bool rightConnected = sourceModel()->data(right, NetworkModel::ConnectionStateRole).toUInt() == NetworkManager::ActiveConnection::Activated;
    const int rightConnectionState = sourceModel()->data(right, NetworkModel::ConnectionStateRole).toUInt();
    const QString rightName = sourceModel()->data(right, NetworkModel::NameRole).toString();
    const SortedConnectionType rightType = connectionTypeToSortedType((NetworkManager::ConnectionSettings::ConnectionType) sourceModel()->data(right, NetworkModel::TypeRole).toUInt());
    const QString rightUuid = sourceModel()->data(right, NetworkModel::UuidRole).toString();
    const int rightSignal = sourceModel()->data(right, NetworkModel::SignalRole).toInt();
    const QDateTime rightDate = sourceModel()->data(right, NetworkModel::TimeStampRole).toDateTime();

    if (leftAvailable < rightAvailable) {
        return true;
    } else if (leftAvailable > rightAvailable) {
        return false;
    }

    if (leftConnected < rightConnected) {
        return true;
    } else if (leftConnected > rightConnected) {
        return false;
    }

    if (leftConnectionState > rightConnectionState) {
        return true;
    } else if (leftConnectionState < rightConnectionState) {
        return false;
    }

    if (leftUuid.isEmpty() && !rightUuid.isEmpty()) {
        return true;
    } else if (!leftUuid.isEmpty() && rightUuid.isEmpty()) {
        return false;
    }

    if (leftType < rightType) {
        return false;
    } else if (leftType > rightType) {
        return true;
    }

    if (leftDate > rightDate) {
        return false;
    } else if (leftDate < rightDate) {
        return true;
    }

    if (leftSignal < rightSignal) {
        return true;
    } else if (leftSignal > rightSignal) {
        return false;
    }

    if (QString::localeAwareCompare(leftName, rightName) > 0) {
        return true;
    } else {
        return false;
    }
}
