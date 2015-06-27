/*
 * Copyright (C) 2014 Jan Grulich <jgrulich@redhat.com>
 *               2015 Ricardo Vieira <ricardo.vieira@tecnico.ulisboa.pt>
 *               2015 Michael Spencer <sonrisesoftware@gmail.com>
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
import Papyros.Network 0.1

ListItem.Standard {
    id: connectionItem;

    text: ItemUniqueName
    //valueText: connState[ConnectionState]
    //subText: SecurityTypeString
    iconName: statusIcon(Type, Signal)
    selected: ConnectionState == 2

    property bool predictableWirelessPassword: !Uuid && Type == Enums.Wireless &&
                                               (SecurityType == Enums.StaticWep || SecurityType == Enums.WpaPsk ||
                                                SecurityType == Enums.Wpa2Psk);
    property bool visiblePasswordDialog: false;

    property var connState: [
        "Unknown",
        "Connecting...",
        "Connected",
        "Disconnecting...",
        "" // Disconnected
    ]

    onClicked: {
        indicator.close()

        if (Uuid || !predictableWirelessPassword) {
            if (ConnectionState == Enums.Deactivated) {
                if (!predictableWirelessPassword && !Uuid) {
                    handler.addAndActivateConnection(DevicePath, SpecificPath);
                } else {
                    handler.activateConnection(ConnectionPath, DevicePath, SpecificPath);
                }
            } else {
                handler.deactivateConnection(ConnectionPath, DevicePath);
            }
        } else if (predictableWirelessPassword) {
            connectDialog.open()
        }
    }

    secondaryItem: [
        ProgressCircle {
            anchors.centerIn: parent
            visible: ConnectionState == 1 || ConnectionState == 3
            width: Units.dp(24)
            height: width
            dashThickness: Units.dp(2)
        },

        Icon {
            anchors.centerIn: parent
            name: "navigation/check"
            color: Theme.primaryColor
            visible: connectionItem.selected
        }
    ]

    InputDialog {
        id: connectDialog

        title: "Connect to Wi-Fi"
        text: "Join '%1'".arg(ItemUniqueName)

        textField.echoMode: TextInput.Password
        placeholderText: "Password"

        validator: RegExpValidator {
            regExp: /.+/
        }

        onAccepted: {
            handler.addAndActivateConnection(DevicePath, SpecificPath, value);
        }
    }
}
