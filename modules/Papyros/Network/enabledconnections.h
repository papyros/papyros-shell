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

#ifndef HAWAII_NM_ENABLED_CONNECTIONS_H
#define HAWAII_NM_ENABLED_CONNECTIONS_H

#include <QObject>

class EnabledConnections : public QObject
{
/**
 * Indicates if overall networking is currently enabled or not
 */
Q_PROPERTY(bool networkingEnabled READ isNetworkingEnabled NOTIFY networkingEnabled)
/**
 * Indicates if wireless is currently enabled or not
 */
Q_PROPERTY(bool wirelessEnabled READ isWirelessEnabled NOTIFY wirelessEnabled)
/**
 * Indicates if the wireless hardware is currently enabled, i.e. the state of the RF kill switch
 */
Q_PROPERTY(bool wirelessHwEnabled READ isWirelessHwEnabled NOTIFY wirelessHwEnabled)
/**
 * Indicates if WiMAX devices are currently enabled or not
 */
Q_PROPERTY(bool wimaxEnabled READ isWimaxEnabled NOTIFY wimaxEnabled)
/**
 * Indicates if the WiMAX hardware is currently enabled, i.e. the state of the RF kill switch.
 */
Q_PROPERTY(bool wimaxHwEnabled READ isWimaxHwEnabled NOTIFY wimaxHwEnabled)
/**
 * Indicates if mobile broadband devices are currently enabled or not.
 */
Q_PROPERTY(bool wwanEnabled READ isWwanEnabled NOTIFY wwanEnabled)
/**
 * Indicates if the mobile broadband hardware is currently enabled, i.e. the state of the RF kill switch.
 */
Q_PROPERTY(bool wwanHwEnabled READ isWwanHwEnabled NOTIFY wwanHwEnabled)
Q_OBJECT
public:
    explicit EnabledConnections(QObject* parent = 0);
    virtual ~EnabledConnections();

    bool isNetworkingEnabled() const;
    bool isWirelessEnabled() const;
    bool isWirelessHwEnabled() const;
    bool isWimaxEnabled() const;
    bool isWimaxHwEnabled() const;
    bool isWwanEnabled() const;
    bool isWwanHwEnabled() const;

public Q_SLOTS:
    void onNetworkingEnabled(bool enabled);
    void onWirelessEnabled(bool enabled);
    void onWirelessHwEnabled(bool enabled);
    void onWimaxEnabled(bool enabled);
    void onWimaxHwEnabled(bool enabled);
    void onWwanEnabled(bool enabled);
    void onWwanHwEnabled(bool enabled);

Q_SIGNALS:
    void networkingEnabled(bool enabled);
    void wirelessEnabled(bool enabled);
    void wirelessHwEnabled(bool enabled);
    void wimaxEnabled(bool enabled);
    void wimaxHwEnabled(bool enabled);
    void wwanEnabled(bool enabled);
    void wwanHwEnabled(bool enabled);

private:
    bool m_networkingEnabled;
    bool m_wirelessEnabled;
    bool m_wirelessHwEnabled;
    bool m_wimaxEnabled;
    bool m_wimaxHwEnabled;
    bool m_wwanEnabled;
    bool m_wwanHwEnabled;
};

#endif // HAWAII_NM_ENABLED_CONNECTIONS_H
