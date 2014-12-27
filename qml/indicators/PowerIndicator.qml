/*
 * Quantum Shell - The desktop shell for Quantum OS following Material Design
 * Copyright (C) 2014 Michael Spencer
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
import org.nemomobile.dbus 2.0
import ".."

Indicator {
    id: indicator
    DBusInterface {
        id: upower

        bus: DBus.SystemBus
        service: "org.freedesktop.UPower"
        iface: "org.freedesktop.UPower"
        path: "/org/freedesktop/UPower"
    }
    Component.onCompleted: {
        upower.typedCall('EnumerateDevices', [], function (result) {
                devicesList.model = result
                //console.log("Devices: "+ result)
        });
    }

    icon: {
        var level = "full"

        print(batteryInfo.percentCharged, batteryInfo.isValid)

        if (batteryInfo.percentCharged < 0.25)
            level = "20"
        else if (batteryInfo.percentCharged < 0.35)
            level = "30"
        else if (batteryInfo.percentCharged < 0.55)
            level = "50"
        else if (batteryInfo.percentCharged < 0.65)
            level = "60"
        else if (batteryInfo.percentCharged < 0.85)
            level = "80"
        else if (batteryInfo.percentCharged < 0.95)
            level = "90"

        print(level)

        if (batteryInfo.isCharging)
            return "device/battery_charging_" + level
        else
            return "device/battery_" + level
    }

    tooltip: "Power"

    dropdown: DropDown {
        implicitHeight: units.dp(200)                       // FIXME please
        height: devicesList.contentHeight + units.dp(15)
        ListView {
            id: devicesList
            anchors.fill: parent
            spacing: units.dp(5)
            delegate: Card {
                height: col.height + units.dp(30)
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: units.dp(5)
                }
                Column {
                    id: col
                    spacing: units.dp(15)
                    anchors.centerIn: parent
                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.margins: units.dp(10)
                        spacing: units.dp(15)
                        Icon {
                            property var types: ["unknown",                 // unknown
                                                 "linepower",               // linepower
                                                 "battery",                 // battery
                                                 "ups",                     // ups
                                                 "hardware/desktop_windows",// monitor
                                                 "hardware/mouse",          // mouse
                                                 "hardware/keyboard",       // keyboard
                                                 "hardware/phone_iphone",   // pda
                                                 "hardware/phone_android"]  // phone
                            name: types[deviceInterface.getProperty('Type')]
                            size: units.dp(18)
                        }
                        Label {
                            text: deviceInterface.getProperty('Vendor')
                        }
                        Label {
                            text: deviceInterface.getProperty('Model')
                        }
                    }
                    ProgressBar {
                        width: parent.width
                        height: units.dp(5)
                        progress: deviceInterface.getProperty('Percentage') / 100
                    }
                }
                DBusInterface {
                    id: deviceInterface
                    bus: DBus.SystemBus
                    service: "org.freedesktop.UPower"
                    iface: "org.freedesktop.UPower.Device"
                    path: modelData
                }
            }
        }
    }

    BatteryInfo {
        id: batteryInfo
    }
}
