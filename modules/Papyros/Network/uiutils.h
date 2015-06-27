/*
    Copyright 2008-2010 Sebastian Kügler <sebas@kde.org>
    Copyright 2013-2014 Jan Grulich <jgrulich@redhat.com>

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License as
    published by the Free Software Foundation; either version 2 of
    the License or (at your option) version 3 or any later version
    accepted by the membership of KDE e.V. (or its successor approved
    by the membership of KDE e.V.), which shall act as a proxy
    defined in Section 14 of version 3 of the license.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef HAWAII_NM_UIUTILS_H
#define HAWAII_NM_UIUTILS_H


#include <NetworkManagerQt/Device>
#include <NetworkManagerQt/ModemDevice>
#include <NetworkManagerQt/WirelessDevice>
#include <NetworkManagerQt/WirelessSetting>
#include <NetworkManagerQt/AccessPoint>
#include <NetworkManagerQt/WimaxNsp>
#include <NetworkManagerQt/Utils>
#include <NetworkManagerQt/BluetoothDevice>
#include <NetworkManagerQt/WimaxDevice>
#include <NetworkManagerQt/WiredDevice>
#include <NetworkManagerQt/VpnConnection>
#include <NetworkManagerQt/VpnSetting>

#if WITH_MODEMMANAGER_SUPPORT
#include <ModemManager/ModemManager.h>
#include <ModemManagerQt/modem.h>
#endif

#include <config.h>

class Q_DECL_EXPORT UiUtils
{
public:

    /**
     * @return a human-readable description for the network interface type for use as label
     * @param type the type of the network interface
     */
    static QString interfaceTypeLabel(const NetworkManager::Device::Type type, const NetworkManager::Device::Ptr iface);

    /**
     * @return a human-readable name for a given network interface according to the configured
     * naming style
     * @param type type of the network interface
     * @param interfaceName name of the network interface (eg eth0)
     */
    static QString prettyInterfaceName(NetworkManager::Device::Type type, const QString &interfaceName);

    /**
     * @return a human-readable description of the connection state of a given network interface
     * @param state The connection state
     */
    static QString connectionStateToString(NetworkManager::Device::State state, const QString &connectionName = QString());

    static QString vpnConnectionStateToString(NetworkManager::VpnConnection::State state);

    static QString iconAndTitleForConnectionSettingsType(NetworkManager::ConnectionSettings::ConnectionType type,
                                                         QString &title);
    /**
     * @return a human-readable description of operation mode.
     * @param mode the operation mode
     */
    static QString operationModeToString(NetworkManager::WirelessDevice::OperationMode mode);

    /**
     * @return string list with a human-readable description of wpa flags.
     * @param flags the wpa flags
     */
    static QStringList wpaFlagsToStringList(NetworkManager::AccessPoint::WpaFlags flags);

    /**
     * @return localized string showing a human-readable connection speed. 1000 is used as base.
     * @param bitrate bitrate of the connection per second
     */
    static QString connectionSpeed(double bitrate);

    /**
     * @param band The band of a wireless network. The value corresponds to the type enum in Knm::WirelessSetting::EnumBand
     * @return A string representation
     */
    static QString wirelessBandToString(NetworkManager::WirelessSetting::FrequencyBand band);

#if WITH_MODEMMANAGER_SUPPORT
    static QString convertAllowedModeToString(ModemManager::Modem::ModemModes mode);
    static QString convertAccessTechnologyToString(ModemManager::Modem::AccessTechnologies tech);
    static QString convertLockReasonToString(MMModemLock reason);
#endif
    static NetworkManager::ModemDevice::Capability modemSubType(NetworkManager::ModemDevice::Capabilities modemCaps);
    static QString convertNspTypeToString(NetworkManager::WimaxNsp::NetworkType type);

    static QString labelFromWirelessSecurity(NetworkManager::WirelessSecurityType type);

    static QString formatDateRelative(const QDateTime & lastUsed);
    static QString formatLastUsedDateRelative(const QDateTime & lastUsed);
};
#endif // UIUTILS_H
