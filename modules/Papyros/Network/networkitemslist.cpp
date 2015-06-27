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

#include "networkitemslist.h"
#include "networkmodelitem.h"

NetworkItemsList::NetworkItemsList(QObject* parent)
    : QObject(parent)
{
}

NetworkItemsList::~NetworkItemsList()
{
    qDeleteAll(m_items);
}

bool NetworkItemsList::contains(const NetworkItemsList::FilterType type, const QString& parameter) const
{
    Q_FOREACH (NetworkModelItem * item, m_items) {
        switch (type) {
            case NetworkItemsList::ActiveConnection:
                if (item->activeConnectionPath() == parameter) {
                    return true;
                }
                break;
            case NetworkItemsList::Connection:
                if (item->connectionPath() == parameter) {
                    return true;
                }
                break;
            case NetworkItemsList::Device:
                if (item->devicePath() == parameter) {
                    return true;
                }
                break;
            case NetworkItemsList::Name:
                if (item->name() == parameter) {
                    return true;
                }
                break;
            case NetworkItemsList::Nsp:
                if (item->nsp() == parameter) {
                    return true;
                }
                break;
            case NetworkItemsList::Ssid:
                if (item->ssid() == parameter) {
                    return true;
                }
                break;
            case NetworkItemsList::Uuid:
                if (item->uuid() == parameter) {
                    return true;
                }
                break;
            case NetworkItemsList::Type:
                break;
            default: break;
        }
    }

    return false;
}

int NetworkItemsList::count() const
{
    return m_items.count();
}

int NetworkItemsList::indexOf(NetworkModelItem* item) const
{
    return m_items.indexOf(item);
}

void NetworkItemsList::insertItem(NetworkModelItem* item)
{
    m_items << item;
}

NetworkModelItem* NetworkItemsList::itemAt(int index) const
{
    return m_items.at(index);
}

QList< NetworkModelItem* > NetworkItemsList::items() const
{
    return m_items;
}

void NetworkItemsList::removeItem(NetworkModelItem* item)
{
    m_items.removeAll(item);
}

QList< NetworkModelItem* > NetworkItemsList::returnItems(const NetworkItemsList::FilterType type, const QString& parameter, const QString& additionalParameter) const
{
    QList<NetworkModelItem*> result;

    Q_FOREACH (NetworkModelItem * item, m_items) {
        switch (type) {
            case NetworkItemsList::ActiveConnection:
                if (item->activeConnectionPath() == parameter) {
                    result << item;
                }
                break;
            case NetworkItemsList::Connection:
                if (item->connectionPath() == parameter) {
                    if (additionalParameter.isEmpty()) {
                        result << item;
                    } else {
                        if (item->devicePath() == additionalParameter) {
                            result << item;
                        }
                    }
                }
                break;
            case NetworkItemsList::Device:
                if (item->devicePath() == parameter) {
                    result << item;
                }
                break;
            case NetworkItemsList::Name:
                if (item->name() == parameter) {
                    result << item;
                }
                break;
            case NetworkItemsList::Nsp:
                if (item->nsp() == parameter) {
                    if (additionalParameter.isEmpty()) {
                        result << item;
                    } else {
                        if (item->devicePath() == additionalParameter) {
                            result << item;
                        }
                    }
                }
                break;
            case NetworkItemsList::Ssid:
                if (item->ssid() == parameter) {
                    if (additionalParameter.isEmpty()) {
                        result << item;
                    } else {
                        if (item->devicePath() == additionalParameter) {
                            result << item;
                        }
                    }
                }
                break;
            case NetworkItemsList::Uuid:
                if (item->uuid() == parameter) {
                    result << item;
                }
                break;
            case NetworkItemsList::Type:
                break;
        }
    }

    return result;
}

QList< NetworkModelItem* > NetworkItemsList::returnItems(const NetworkItemsList::FilterType type, NetworkManager::ConnectionSettings::ConnectionType typeParameter) const
{
    QList<NetworkModelItem*> result;

    Q_FOREACH (NetworkModelItem * item, m_items) {
        if (type == NetworkItemsList::Type) {
            if (item->type() == typeParameter) {
                result << item;
            }
        }
    }
    return result;
}
