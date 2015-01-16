/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 * Copyright (C) 2015 Michael Spencer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.0
import Material 0.1
import Material.ListItems 0.1 as ListItem
import Material.Desktop 0.1
import Material.Extras 0.1

View {
    fullHeight: true

    elevation: 2
    backgroundColor: "#fafafa"

    property bool showing: false

    anchors {
        right: parent.right
        top: parent.top
        bottom: parent.bottom

        rightMargin: showing ? 0 : -width - units.dp(5)

        Behavior on rightMargin {
            NumberAnimation { duration: 200 }
        }
    }

    width: units.dp(265)

    Column {
        width: parent.width

        // TODO: Replace with real data
        ListItem.Subtitled {
            text: "Michael Spencer"
            subText: "sonrisesoftware@gmail.com"
            showDivider: true
        }

        ListItem.Standard {
            text: "Sound"
            valueText: sound.muted ? "Muted" : "Volume at %1%".arg(sound.master)

            action: Icon {
                anchors.centerIn: parent
                name: sound.muted ? "av/volume_off"
                      : sound.master <= 33 ? "av/volume_mute"
                      : sound.master >= 67 ? "av/volume_up"
                      : "av/volume_down"
            }
        }

        // TODO: Replace with real data
        ListItem.Standard {
            text: "Wi-Fi"
            valueText: "Not connected"

            action: Icon {
                anchors.centerIn: parent
                name: "device/signal_wifi_3_bar"
            }
        }

        // TODO: Replace with real data
        ListItem.Standard {
            text: "Bluetooth"
            secondaryItem: Switch {
                id: bluetoothSwitch
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }

            onTriggered: bluetoothSwitch.checked = !bluetoothSwitch.checked

            action: Icon {
                anchors.centerIn: parent
                name: "device/bluetooth"
            }
        }

        Repeater {
            model: upower.devices

            delegate: ListItem.Standard {
                text: modelData == upower.primaryDevice ? "Battery" : vendor
                //progress: percentage/100
                valueText: upower.deviceSummary(modelData)
                visible: type != UPowerDeviceType.LinePower

                action: Icon {
                    anchors.centerIn: parent
                    name: upower.deviceIcon(modelData)
                }
            }
        }

        ListItem.Standard {
            text: "System settings..."
        }

        ListItem.Standard {
            text: "Install or update software..."
        }
    }

    Row {
        anchors {
            bottomMargin: units.dp(36)
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        spacing: units.dp(30)

        IconAction {
            size: units.dp(30)
            name: "action/settings"
        }

        IconAction {
            size: units.dp(30)
            name: "action/lock"

            // TODO: replace with call to Logind DBus
            onTriggered: shell.state = "locked"
        }

        IconAction {
            size: units.dp(30)
            name: "action/settings_power"
        }
    }
}
