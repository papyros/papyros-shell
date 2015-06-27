/*
    Copyright 2008-2010 Sebastian Kügler <sebas@kde.org>
    Copyright 2013-2014 Jan Grulich <jgrulich@redhat.com>
    Copyright 2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>

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

// Own
#include "uiutils.h"

#include "debug.h"

#include <NetworkManagerQt/BluetoothDevice>
#include <NetworkManagerQt/Manager>
#include <NetworkManagerQt/Device>
#include <NetworkManagerQt/AccessPoint>
#include <NetworkManagerQt/WiredDevice>
#include <NetworkManagerQt/WirelessDevice>
#include <NetworkManagerQt/WirelessSetting>

#if WITH_MODEMMANAGER_SUPPORT
#include <ModemManagerQt/manager.h>
#include <ModemManagerQt/modem.h>
#include <ModemManagerQt/modemdevice.h>
#include <ModemManagerQt/modem3gpp.h>
#include <ModemManagerQt/modemcdma.h>
#endif

// Qt
#include <QSizeF>
#include <QHostAddress>

#include <QString>

using namespace NetworkManager;

QString UiUtils::interfaceTypeLabel(const NetworkManager::Device::Type type, const NetworkManager::Device::Ptr iface)
{
    QString deviceText;
    switch (type) {
    case NetworkManager::Device::Wifi:
        /*: title of the interface widget in nm's popup */
        deviceText = QObject::tr("Wi-Fi");
        break;
    case NetworkManager::Device::Bluetooth:
        /*: title of the interface widget in nm's popup */
        deviceText = QObject::tr("Bluetooth");
        break;
    case NetworkManager::Device::Wimax:
        /*: title of the interface widget in nm's popup */
        deviceText = QObject::tr("WiMAX");
        break;
    case NetworkManager::Device::InfiniBand:
        /*: title of the interface widget in nm's popup */
        deviceText = QObject::tr("Infiniband");
        break;
    case NetworkManager::Device::Adsl:
        /*: title of the interface widget in nm's popup */
        deviceText = QObject::tr("ADSL");
        break;
    case NetworkManager::Device::Bond:
        /*: title of the interface widget in nm's popup */
        deviceText = QObject::tr("Virtual (bond)");
        break;
    case NetworkManager::Device::Bridge:
        /*: title of the interface widget in nm's popup */
        deviceText = QObject::tr("Virtual (bridge)");
        break;
    case NetworkManager::Device::Vlan:
        /*: title of the interface widget in nm's popup */
        deviceText = QObject::tr("Virtual (vlan)");
        break;
#if NM_CHECK_VERSION(0, 9, 10)
    case NetworkManager::Device::Team:
        /*: title of the interface widget in nm's popup */
        deviceText = QObject::tr("Virtual (team)");
        break;
#endif
    case NetworkManager::Device::Modem: {
        const NetworkManager::ModemDevice::Ptr nmModemIface = iface.objectCast<NetworkManager::ModemDevice>();
        if (nmModemIface) {
            switch(modemSubType(nmModemIface->currentCapabilities())) {
            case NetworkManager::ModemDevice::Pots:
                /*: title of the interface widget in nm's popup */
                deviceText = QObject::tr("Serial Modem");
                break;
            case NetworkManager::ModemDevice::GsmUmts:
            case NetworkManager::ModemDevice::CdmaEvdo:
            case NetworkManager::ModemDevice::Lte:
                /*: title of the interface widget in nm's popup */
                deviceText = QObject::tr("Mobile Broadband");
                break;
            case NetworkManager::ModemDevice::NoCapability:
                qCWarning(NM) << "Unhandled modem sub type: NetworkManager::ModemDevice::NoCapability";
                break;
            }
        }
    }
        break;
    case NetworkManager::Device::Ethernet:
    default:
        /*: title of the interface widget in nm's popup */
        deviceText = QObject::tr("Wired Ethernet");
        break;
    }
    return deviceText;
}

QString UiUtils::iconAndTitleForConnectionSettingsType(NetworkManager::ConnectionSettings::ConnectionType type, QString &title)
{
    QString text;
    QString icon = "network-wired";
    switch (type) {
    case ConnectionSettings::Adsl:
        text = QObject::tr("ADSL");
        icon = "modem";
        break;
    case ConnectionSettings::Pppoe:
        text = QObject::tr("DSL");
        icon = "modem";
        break;
    case ConnectionSettings::Bluetooth:
        text = QObject::tr("Bluetooth");
        icon = "preferences-system-bluetooth";
        break;
    case ConnectionSettings::Bond:
        text = QObject::tr("Bond");
        break;
    case ConnectionSettings::Bridge:
        text = QObject::tr("Bridge");
        break;
    case ConnectionSettings::Gsm:
    case ConnectionSettings::Cdma:
        text = QObject::tr("Mobile broadband");
        icon = "phone";
        break;
    case ConnectionSettings::Infiniband:
        text = QObject::tr("Infiniband");
        break;
    case ConnectionSettings::OLPCMesh:
        text = QObject::tr("Olpc mesh");
        break;
    case ConnectionSettings::Vlan:
        text = QObject::tr("VLAN");
        break;
    case ConnectionSettings::Vpn:
        text = QObject::tr("VPN");
        icon = "secure-card";
        break;
    case ConnectionSettings::Wimax:
        text = QObject::tr("WiMAX");
        icon = "network-wireless";
        break;
    case ConnectionSettings::Wired:
        text = QObject::tr("Wired Ethernet");
        icon = "network-wired";
        break;
    case ConnectionSettings::Wireless:
        text = QObject::tr("Wi-Fi");
        icon = "network-wireless";
        break;
#if NM_CHECK_VERSION(0, 9, 10)
    case ConnectionSettings::Team:
        text = QObject::tr("Team");
        break;
#endif
    default:
        text = QObject::tr("Unknown connection type");
        break;
    }
    title = text;
    return icon;
}

QString UiUtils::prettyInterfaceName(NetworkManager::Device::Type type, const QString &interfaceName)
{
    QString ret;
    switch (type) {
    case NetworkManager::Device::Wifi:
        ret = QObject::tr("Wireless Interface (%1)").arg(interfaceName);
        break;
    case NetworkManager::Device::Ethernet:
        ret = QObject::tr("Wired Interface (%1)").arg(interfaceName);
        break;
    case NetworkManager::Device::Bluetooth:
        ret = QObject::tr("Bluetooth (%1)").arg(interfaceName);
        break;
    case NetworkManager::Device::Modem:
        ret = QObject::tr("Modem (%1)").arg(interfaceName);
        break;
    case NetworkManager::Device::Adsl:
        ret = QObject::tr("ADSL (%1)").arg(interfaceName);
        break;
    case NetworkManager::Device::Vlan:
        ret = QObject::tr("VLan (%1)").arg(interfaceName);
        break;
    case NetworkManager::Device::Bridge:
        ret = QObject::tr("Bridge (%1)").arg(interfaceName);
        break;
    default:
        ret = interfaceName;
    }
    return ret;
}

QString UiUtils::connectionStateToString(NetworkManager::Device::State state, const QString &connectionName)
{
    QString stateString;
    switch (state) {
        case NetworkManager::Device::UnknownState:
            /*: description of unknown network interface state */
            stateString = QObject::tr("Unknown");
            break;
        case NetworkManager::Device::Unmanaged:
            /*: description of unmanaged network interface state */
            stateString = QObject::tr("Unmanaged");
            break;
        case NetworkManager::Device::Unavailable:
            /*: description of unavailable network interface state */
            stateString = QObject::tr("Unavailable");
            break;
        case NetworkManager::Device::Disconnected:
            /*: description of unconnected network interface state */
            stateString = QObject::tr("Not connected");
            break;
        case NetworkManager::Device::Preparing:
            /*: description of preparing to connect network interface state */
            stateString = QObject::tr("Preparing to connect");
            break;
        case NetworkManager::Device::ConfiguringHardware:
            /*: description of configuring hardware network interface state */
            stateString = QObject::tr("Configuring interface");
            break;
        case NetworkManager::Device::NeedAuth:
            /*: description of waiting for authentication network interface state */
            stateString = QObject::tr("Waiting for authorization");
            break;
        case NetworkManager::Device::ConfiguringIp:
            /*: network interface doing dhcp request in most cases */
            stateString = QObject::tr("Setting network address");
            break;
        case NetworkManager::Device::CheckingIp:
            /*: is other action required to fully connect? captive portals, etc. */
            stateString = QObject::tr("Checking further connectivity");
            break;
        case NetworkManager::Device::WaitingForSecondaries:
            /*: a secondary connection (e.g. VPN) has to be activated first to continue */
            stateString = QObject::tr("Waiting for a secondary connection");
            break;
        case NetworkManager::Device::Activated:
            if (connectionName.isEmpty()) {
                /*: network interface connected state label */
                stateString = QObject::tr("Connected");
            } else {
                /*: network interface connected state label */
                stateString = QObject::tr("Connected to %1").arg(connectionName);
            }
            break;
        case NetworkManager::Device::Deactivating:
            /*: network interface disconnecting state label */
            stateString = QObject::tr("Deactivating connection");
            break;
        case NetworkManager::Device::Failed:
            /*: description of unknown network interface state */
            stateString = QObject::tr("Connection Failed");
            break;
        default:
            /*: interface state */
            stateString = QObject::tr("Error: Invalid state");
    }
    return stateString;
}

QString UiUtils::vpnConnectionStateToString(VpnConnection::State state)
{
    QString stateString;
    switch (state) {
        case VpnConnection::Unknown:
            /*: The state of the VPN connection is unknown */
            stateString = QObject::tr("Unknown");
            break;
        case VpnConnection::Prepare:
            /*: The VPN connection is preparing to connect */
            stateString = QObject::tr("Preparing to connect");
            break;
        case VpnConnection::NeedAuth:
            /*: The VPN connection needs authorization credentials */
            stateString = QObject::tr("Needs authorization");
            break;
        case VpnConnection::Connecting:
            /*: The VPN connection is being established */
            stateString = QObject::tr("Connecting");
            break;
        case VpnConnection::GettingIpConfig:
            /*: The VPN connection is getting an IP address */
            stateString = QObject::tr("Setting network address");
            break;
        case VpnConnection::Activated:
            /*: The VPN connection is active */
            stateString = QObject::tr("Activated");
            break;
        case VpnConnection::Failed:
            /*: The VPN connection failed */
            stateString = QObject::tr("Failed");
            break;
        case VpnConnection::Disconnected:
            /*: The VPN connection is disconnected */
            stateString = QObject::tr("Failed");
            break;
        default:
            /*: interface state */
            stateString = QObject::tr("interface state", "Error: Invalid state");    }
    return stateString;
}

QString UiUtils::operationModeToString(NetworkManager::WirelessDevice::OperationMode mode)
{
    QString modeString;
    switch (mode) {
        case NetworkManager::WirelessDevice::WirelessDevice::Unknown:
            /*: wireless network operation mode */
            modeString = QObject::tr("Unknown");
            break;
        case NetworkManager::WirelessDevice::Adhoc:
            /*: wireless network operation mode */
            modeString = QObject::tr("Adhoc");
            break;
        case NetworkManager::WirelessDevice::WirelessDevice::Infra:
            /*: wireless network operation mode */
            modeString = QObject::tr("Infrastructure");
            break;
        case NetworkManager::WirelessDevice::WirelessDevice::ApMode:
            /*: wireless network operation mode */
            modeString = QObject::tr("Access point");
            break;
        default:
            modeString = QT_TR_NOOP("INCORRECT MODE FIX ME");
    }
    return modeString;
}

QStringList UiUtils::wpaFlagsToStringList(NetworkManager::AccessPoint::WpaFlags flags)
{
    /* for testing purposes
    flags = NetworkManager::AccessPoint::PairWep40
            | NetworkManager::AccessPoint::PairWep104
            | NetworkManager::AccessPoint::PairTkip
            | NetworkManager::AccessPoint::PairCcmp
            | NetworkManager::AccessPoint::GroupWep40
            | NetworkManager::AccessPoint::GroupWep104
            | NetworkManager::AccessPoint::GroupTkip
            | NetworkManager::AccessPoint::GroupCcmp
            | NetworkManager::AccessPoint::KeyMgmtPsk
            | NetworkManager::AccessPoint::KeyMgmt8021x; */

    QStringList flagList;

    if (flags.testFlag(NetworkManager::AccessPoint::PairWep40))
        /*: wireless network cipher */
        flagList.append(QObject::tr("Pairwise WEP40"));
    if (flags.testFlag(NetworkManager::AccessPoint::PairWep104))
        /*: wireless network cipher */
        flagList.append(QObject::tr("Pairwise WEP104"));
    if (flags.testFlag(NetworkManager::AccessPoint::PairTkip))
        /*: wireless network cipher */
        flagList.append(QObject::tr("Pairwise TKIP"));
    if (flags.testFlag(NetworkManager::AccessPoint::PairCcmp))
        /*: wireless network cipher */
        flagList.append(QObject::tr("Pairwise CCMP"));
    if (flags.testFlag(NetworkManager::AccessPoint::GroupWep40))
        /*: wireless network cipher */
        flagList.append(QObject::tr("Group WEP40"));
    if (flags.testFlag(NetworkManager::AccessPoint::GroupWep104))
        /*: wireless network cipher */
        flagList.append(QObject::tr("Group WEP104"));
    if (flags.testFlag(NetworkManager::AccessPoint::GroupTkip))
        /*: wireless network cipher */
        flagList.append(QObject::tr("Group TKIP"));
    if (flags.testFlag(NetworkManager::AccessPoint::GroupCcmp))
        /*: wireless network cipher */
        flagList.append(QObject::tr("Group CCMP"));
    if (flags.testFlag(NetworkManager::AccessPoint::KeyMgmtPsk))
        /*: wireless network cipher */
        flagList.append(QObject::tr("PSK"));
    if (flags.testFlag(NetworkManager::AccessPoint::KeyMgmt8021x))
        /*: wireless network cipher */
        flagList.append(QObject::tr("802.1x"));

    return flagList;
}


QString UiUtils::connectionSpeed(double bitrate)
{
    QString out;
    if (bitrate < 1000) {
        /*: connection speed */
        out = QObject::tr("%1 Bit/s").arg(bitrate);
    } else if (bitrate < 1000000) {
        /*: connection speed */
        out = QObject::tr("%1 MBit/s").arg(bitrate/1000);
    } else {
        /*: connection speed */
        out = QObject::tr("%1 GBit/s").arg(bitrate/1000000);
    }
    return out;
}

QString UiUtils::wirelessBandToString(NetworkManager::WirelessSetting::FrequencyBand band)
{
    switch (band) {
        case NetworkManager::WirelessSetting::Automatic:
            return QLatin1String("automatic");
            break;
        case NetworkManager::WirelessSetting::A:
            return QLatin1String("a");
            break;
        case NetworkManager::WirelessSetting::Bg:
            return QLatin1String("b/g");
            break;
    }

    return QString();
}

#if WITH_MODEMMANAGER_SUPPORT
QString UiUtils::convertAllowedModeToString(ModemManager::Modem::ModemModes modes)
{
    if (modes.testFlag(MM_MODEM_MODE_4G)) {
        /*: Gsm modes (2G/3G/any) */
        return QObject::tr("LTE");
    } else if (modes.testFlag(MM_MODEM_MODE_3G)) {
        /*: Gsm modes (2G/3G/any) */
        return QObject::tr("UMTS/HSxPA");
    } else if (modes.testFlag(MM_MODEM_MODE_2G)) {
        /*: Gsm modes (2G/3G/any) */
        return QObject::tr("GPRS/EDGE");
    } else if (modes.testFlag(MM_MODEM_MODE_CS)) {
        /*: Gsm modes (2G/3G/any) */
        return QObject::tr("GSM");
    } else if (modes.testFlag(MM_MODEM_MODE_ANY)) {
        /*: Gsm modes (2G/3G/any) */
        return QObject::tr("Any");
    }

    /*: Gsm modes (2G/3G/any) */
    return QObject::tr("Any");
}

QString UiUtils::convertAccessTechnologyToString(ModemManager::Modem::AccessTechnologies tech)
{
    if (tech.testFlag(MM_MODEM_ACCESS_TECHNOLOGY_LTE)) {
        /*: Cellular access technology */
        return QObject::tr("LTE");
    } else if (tech.testFlag(MM_MODEM_ACCESS_TECHNOLOGY_EVDOB)) {
        /*: Cellular access technology */
        return QObject::tr("CDMA2000 EVDO revision B");
    } else if (tech.testFlag(MM_MODEM_ACCESS_TECHNOLOGY_EVDOA)) {
        /*: Cellular access technology */
        return QObject::tr("CDMA2000 EVDO revision A");
    } else if (tech.testFlag(MM_MODEM_ACCESS_TECHNOLOGY_EVDO0)) {
        /*: Cellular access technology */
        return QObject::tr("CDMA2000 EVDO revision 0");
    } else if (tech.testFlag(MM_MODEM_ACCESS_TECHNOLOGY_1XRTT)) {
        /*: Cellular access technology */
        return QObject::tr("CDMA2000 1xRTT");
    } else if (tech.testFlag(MM_MODEM_ACCESS_TECHNOLOGY_HSPA_PLUS)) {
        /*: Cellular access technology */
        return QObject::tr("HSPA+");
    } else if (tech.testFlag(MM_MODEM_ACCESS_TECHNOLOGY_HSPA)) {
        /*: Cellular access technology */
        return QObject::tr("HSPA");
    } else if (tech.testFlag(MM_MODEM_ACCESS_TECHNOLOGY_HSUPA)) {
        /*: Cellular access technology */
        return QObject::tr("HSUPA");
    } else if (tech.testFlag(MM_MODEM_ACCESS_TECHNOLOGY_HSDPA)) {
        /*: Cellular access technology */
        return QObject::tr("HSDPA");
    } else if (tech.testFlag(MM_MODEM_ACCESS_TECHNOLOGY_UMTS)) {
        /*: Cellular access technology */
        return QObject::tr("UMTS");
    } else if (tech.testFlag(MM_MODEM_ACCESS_TECHNOLOGY_EDGE)) {
        /*: Cellular access technology */
        return QObject::tr("EDGE");
    } else if (tech.testFlag(MM_MODEM_ACCESS_TECHNOLOGY_GPRS)) {
        /*: Cellular access technology */
        return QObject::tr("GPRS");
    } else if (tech.testFlag(MM_MODEM_ACCESS_TECHNOLOGY_GSM_COMPACT)) {
        /*: Cellular access technology */
        return QObject::tr("Compact GSM");
    } else if (tech.testFlag(MM_MODEM_ACCESS_TECHNOLOGY_GSM)) {
        /*: Cellular access technology */
        return QObject::tr("GSM");
    } else if (tech.testFlag(MM_MODEM_ACCESS_TECHNOLOGY_POTS)) {
        /*: Analog wireline modem */
        return QObject::tr("Analog");
    } else if (tech.testFlag(MM_MODEM_ACCESS_TECHNOLOGY_UNKNOWN)) {
        /*: Unknown cellular access technology */
        return QObject::tr("Unknown");
    } else if (tech.testFlag(MM_MODEM_ACCESS_TECHNOLOGY_ANY)) {
        /*: Any cellular access technology */
        return QObject::tr("Any");
    }

    /*: Unknown cellular access technology */
    return QObject::tr("Unknown");
}

QString UiUtils::convertLockReasonToString(MMModemLock reason)
{
    switch (reason) {
    case MM_MODEM_LOCK_NONE:
        /*: possible SIM lock reason */
        return QObject::tr("Modem is unlocked.");
    case MM_MODEM_LOCK_SIM_PIN:
        /*: possible SIM lock reason */
        return QObject::tr("SIM requires the PIN code.");
    case MM_MODEM_LOCK_SIM_PIN2:
        /*: possible SIM lock reason */
        return QObject::tr("SIM requires the PIN2 code.");
    case MM_MODEM_LOCK_SIM_PUK:
        /*: possible SIM lock reason */
        return QObject::tr("SIM requires the PUK code.");
    case MM_MODEM_LOCK_SIM_PUK2:
        /*: possible SIM lock reason */
        return QObject::tr("SIM requires the PUK2 code.");
    case MM_MODEM_LOCK_PH_SP_PIN:
        /*: possible SIM lock reason */
        return QObject::tr("Modem requires the service provider PIN code.");
    case MM_MODEM_LOCK_PH_SP_PUK:
        /*: possible SIM lock reason */
        return QObject::tr("Modem requires the service provider PUK code.");
    case MM_MODEM_LOCK_PH_NET_PIN:
        /*: possible SIM lock reason */
        return QObject::tr("Modem requires the network PIN code.");
    case MM_MODEM_LOCK_PH_NET_PUK:
        /*: possible SIM lock reason */
        return QObject::tr("Modem requires the network PUK code.");
    case MM_MODEM_LOCK_PH_SIM_PIN:
        /*: possible SIM lock reason */
        return QObject::tr("Modem requires the PIN code.");
    case MM_MODEM_LOCK_PH_CORP_PIN:
        /*: possible SIM lock reason */
        return QObject::tr("Modem requires the corporate PIN code.");
    case MM_MODEM_LOCK_PH_CORP_PUK:
        /*: possible SIM lock reason */
        return QObject::tr("Modem requires the corporate PUK code.");
    case MM_MODEM_LOCK_PH_FSIM_PIN:
        /*: possible SIM lock reason */
        return QObject::tr("Modem requires the PH-FSIM PIN code.");
    case MM_MODEM_LOCK_PH_FSIM_PUK:
        /*: possible SIM lock reason */
        return QObject::tr("Modem requires the PH-FSIM PUK code.");
    case MM_MODEM_LOCK_PH_NETSUB_PIN:
        /*: possible SIM lock reason */
        return QObject::tr("Modem requires the network subset PIN code.");
    case MM_MODEM_LOCK_PH_NETSUB_PUK:
        /*: possible SIM lock reason */
        return QObject::tr("Modem requires the network subset PUK code.");
    case MM_MODEM_LOCK_UNKNOWN:
    default:
        /*: possible SIM lock reason */
        return QObject::tr("Lock reason unknown.");
    }
}
#endif

QString UiUtils::convertNspTypeToString(WimaxNsp::NetworkType type)
{
    switch (type) {
        /*: unknown Wimax NSP type */
        case WimaxNsp::Unknown: return QObject::tr("Unknown");
        case WimaxNsp::Home: return QObject::tr("Home");
        case WimaxNsp::Partner: return QObject::tr("Partner");
        case WimaxNsp::RoamingPartner: return QObject::tr("Roaming partner");
    }

    /*: Unknown */
    return QObject::tr("Unknown Wimax NSP type");
}

NetworkManager::ModemDevice::Capability UiUtils::modemSubType(NetworkManager::ModemDevice::Capabilities modemCaps)
{
    if (modemCaps & NetworkManager::ModemDevice::Lte) {
        return NetworkManager::ModemDevice::Lte;
    } else if (modemCaps & NetworkManager::ModemDevice::CdmaEvdo) {
        return NetworkManager::ModemDevice::CdmaEvdo;
    } else if (modemCaps & NetworkManager::ModemDevice::GsmUmts) {
        return NetworkManager::ModemDevice::GsmUmts;
    } else if (modemCaps & NetworkManager::ModemDevice::Pots) {
        return NetworkManager::ModemDevice::Pots;
    }
    return NetworkManager::ModemDevice::NoCapability;
}

QString UiUtils::labelFromWirelessSecurity(NetworkManager::WirelessSecurityType type)
{
    QString tip;
    switch (type) {
        case NetworkManager::NoneSecurity:
            /*: @label no security */
            tip = QObject::tr("Insecure");
            break;
        case NetworkManager::StaticWep:
            /*: @label WEP security */
            tip = QObject::tr("WEP");
            break;
        case NetworkManager::Leap:
            /*: @label LEAP security */
            tip = QObject::tr("LEAP");
            break;
        case NetworkManager::DynamicWep:
            /*: @label Dynamic WEP security */
            tip = QObject::tr("Dynamic WEP");
            break;
        case NetworkManager::WpaPsk:
            /*: @label WPA-PSK security */
            tip = QObject::tr("WPA-PSK");
            break;
        case NetworkManager::WpaEap:
            /*: @label WPA-EAP security */
            tip = QObject::tr("WPA-EAP");
            break;
        case NetworkManager::Wpa2Psk:
            /*: @label WPA2-PSK security */
            tip = QObject::tr("WPA2-PSK");
            break;
        case NetworkManager::Wpa2Eap:
            /*: @label WPA2-EAP security */
            tip = QObject::tr("WPA2-EAP");
            break;
        default:
            /*: @label unknown security */
            tip = QObject::tr("Unknown security type");
            break;
    }
    return tip;
}

QString UiUtils::formatDateRelative(const QDateTime & lastUsed)
{
    QString lastUsedText;
    if (lastUsed.isValid()) {
        const QDateTime now = QDateTime::currentDateTime();
        if (lastUsed.daysTo(now) == 0 ) {
            const int secondsAgo = lastUsed.secsTo(now);
            if (secondsAgo < (60 * 60 )) {
                const int minutesAgo = secondsAgo / 60;
                /*: Label for last used time for a network connection used in the last hour, as the number of minutes since usage */
                lastUsedText = QObject::tr("%n minute(s) ago", "", minutesAgo);
            } else {
                const int hoursAgo = secondsAgo / (60 * 60);
                /*: Label for last used time for a network connection used in the last day, as the number of hours since usage */
                lastUsedText = QObject::tr("%n hour(s) ago", "", hoursAgo);
            }
        } else if (lastUsed.daysTo(now) == 1) {
            /*: Label for last used time for a network connection used the previous day */
            lastUsedText = QObject::tr("Yesterday");
        } else {
            lastUsedText = QLocale().toString(lastUsed.date(), QLocale::ShortFormat);
        }
    } else {
        /*: Label for last used time for a network connection that has never been used */
        lastUsedText =  QObject::tr("Never");
    }
    return lastUsedText;
}

QString UiUtils::formatLastUsedDateRelative(const QDateTime & lastUsed)
{
    QString lastUsedText;
    if (lastUsed.isValid()) {
        const QDateTime now = QDateTime::currentDateTime();
        if (lastUsed.daysTo(now) == 0 ) {
            const int secondsAgo = lastUsed.secsTo(now);
            if (secondsAgo < (60 * 60 )) {
                const int minutesAgo = secondsAgo / 60;
                /*: Label for last used time for a network connection used in the last hour, as the number of minutes since usage */
                lastUsedText = QObject::tr("Last used %n minute(s) ago", "", minutesAgo);
            } else {
                const int hoursAgo = secondsAgo / (60 * 60);
                /*: Label for last used time for a network connection used in the last day, as the number of hours since usage */
                lastUsedText = QObject::tr("Last used %n hour(s) ago", "", hoursAgo);
            }
        } else if (lastUsed.daysTo(now) == 1) {
            /*: Label for last used time for a network connection used the previous day */
            lastUsedText = QObject::tr("Last used yesterday");
        } else {
            lastUsedText = QObject::tr("Last used on %1").arg(QLocale().toString(lastUsed.date(), QLocale::ShortFormat));
        }
    } else {
        /*: Label for last used time for a network connection that has never been used */
        lastUsedText =  QObject::tr("Never used");
    }
    return lastUsedText;
}
