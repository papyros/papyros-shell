/*
 * Copyright (C) 2014 Jan Grulich <jgrulich@redhat.com>
 * Copyright (C) 2015 Ricardo Vieira <ricardo.vieira@tecnico.ulisboa.pt>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 */

import QtQuick 2.2
import Material 0.1
import Material.ListItems 0.1 as ListItem
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.networkmanagement 0.2 as PlasmaNM

Column {
    id: connectionItem;
    width: parent.width
    property bool predictableWirelessPassword: !Uuid && Type == PlasmaNM.Enums.Wireless &&
                                               (SecurityType == PlasmaNM.Enums.StaticWep || SecurityType == PlasmaNM.Enums.WpaPsk ||
                                                SecurityType == PlasmaNM.Enums.Wpa2Psk);
    property bool visiblePasswordDialog: false;

    property var connState: [
        "Unknown",
        "Connecting...",
        "Connected",
        "Disconnecting...",
        "" // Disconnected
    ]

    ListItem.Subtitled {
        id: data
        width: parent.width
        text: ItemUniqueName
        valueText: connState[ConnectionState]
        subText: SecurityTypeString

        action: Icon {
            anchors.centerIn: parent
            name: statusIcon(Type, Signal)
        }
        onClicked: changeState()
    }

    TextField {
        id: passwordField
        height: visiblePasswordDialog ? implicitHeight : 0
        visible: height != 0
        anchors {
            left: parent.left
            right: parent.right
            margins: units.dp(20)
        }
        input.echoMode: TextInput.Password
        placeholderText: "Password"
        onAccepted: changeState()
        Behavior on height {
            NumberAnimation { duration: 200 }
        }
    }

    function changeState() {
        if (Uuid || !predictableWirelessPassword || visiblePasswordDialog) {
            if (ConnectionState == PlasmaNM.Enums.Deactivated) {
                if (!predictableWirelessPassword && !Uuid) {
                    handler.addAndActivateConnection(DevicePath, SpecificPath);
                } else if (visiblePasswordDialog) {
                    if (passwordField.text != "") {
                        handler.addAndActivateConnection(DevicePath, SpecificPath, passwordField.text);
                        visiblePasswordDialog = false;
                    } else {
                        //connectionItem.clicked();
                    }
                } else {
                    handler.activateConnection(ConnectionPath, DevicePath, SpecificPath);
                }
            } else {
                handler.deactivateConnection(ConnectionPath, DevicePath);
            }
        } else if (predictableWirelessPassword) {
            visiblePasswordDialog = true;
        }
    }

    function statusIcon(type, signal) {
        var strength = parseInt(signal*4/100)
        switch (type) {
            case PlasmaNM.Enums.UnknownConnectionType:
            case PlasmaNM.Enums.Adsl:
            case PlasmaNM.Enums.Bluetooth:
            case PlasmaNM.Enums.Bond:
            case PlasmaNM.Enums.Bridge:
            case PlasmaNM.Enums.Cdma:
            case PlasmaNM.Enums.Gsm:
                return "device/signal_cellular_" + strength + "_bar"
            case PlasmaNM.Enums.Infiniband:
            case PlasmaNM.Enums.OLPCMesh:
            case PlasmaNM.Enums.Pppoe:
            case PlasmaNM.Enums.Vlan:
            case PlasmaNM.Enums.Vpn:
                return "action/lock"
            case PlasmaNM.Enums.Wimax:
            case PlasmaNM.Enums.Wired:
                return "action/settings_ethernet"
            case PlasmaNM.Enums.Wireless:
                // This is the only way i found to check if the item is a theadering device
                if (signal)
                    return "device/signal_wifi_" + strength + "_bar"
                else
                    return "device/wifi_tethering"
        }
    }
}
