/*
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

#ifndef HAWAII_NM_ENUMS_H
#define HAWAII_NM_ENUMS_H

#include <QObject>

class Enums : public QObject
{
Q_OBJECT
Q_ENUMS(ConnectionStatus)
Q_ENUMS(ConnectionType)
Q_ENUMS(SecurityType)

public:
    explicit Enums(QObject* parent = 0);
    virtual ~Enums();

    enum ConnectionStatus {
        UnknownState = 0,
        Activating,
        Activated,
        Deactivating,
        Deactivated
    };

    enum ConnectionType {
        UnknownConnectionType = 0,
        Adsl,
        Bluetooth,
        Bond,
        Bridge,
        Cdma,
        Gsm,
        Infiniband,
        OLPCMesh,
        Pppoe,
        Vlan,
        Vpn,
        Wimax,
        Wired,
        Wireless
    };

    enum SecurityType {
        UnknownSecurity = -1,
        NoneSecurity = 0,
        StaticWep,
        DynamicWep,
        Leap,
        WpaPsk,
        WpaEap,
        Wpa2Psk,
        Wpa2Eap
    };
};

#endif // HAWAII_NM_ENUMS_H
