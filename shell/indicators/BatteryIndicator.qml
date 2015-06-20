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
import Material.Extras 0.1
import Papyros.Desktop 0.1
import Material.ListItems 0.1 as ListItem

Indicator {
    id: indicator

    iconName: deviceChargeIcon(hardware.primaryBattery)
    tooltip: deviceSummary(hardware.primaryBattery)
    color: {
        if (hardware.primaryBattery.chargeState != Battery.Charging) {
            if (hardware.primaryBattery.chargePercent < 10) {
                return Palette.colors.red["500"]
            } else if (hardware.primaryBattery.chargePercent < 15) {
                return Palette.colors.orange["500"]
            } else if (hardware.primaryBattery.chargePercent < 20) {
                return Palette.colors.yellow["500"]
            }
        }

        return "transparent"
    }

    view: Column {

        // TODO: Re-enable once we have a brightness API
        // ListItem.Subtitled {
        //     text: "Screen Brightness"
        //     valueText: "25%"
        //     content: Slider {
        //         width: parent.width
        //         value: 0.25
        //         anchors.verticalCenter: parent.verticalCenter
        //         anchors.verticalCenterOffset: Units.dp(7)
        //     }
        //
        //     showDivider: true
        // }

        Repeater {
            model: hardware.batteries
            delegate: ListItem.Subtitled {
                iconSource: deviceIcon(modelData)
                text: deviceTitle(modelData)
                valueText: deviceSummary(modelData)
                content: ProgressBar {
                    value: chargePercent/100
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    function deviceTitle(battery) {
        if (isMouse(battery)) {
            return battery.product
        } else if (battery.type == Battery.PrimaryBattery) {
            return "Laptop battery"
        } else {
            return battery.product
        }
    }

    function deviceIcon(battery) {
        print("Battery type", battery.name, battery.type, battery.vendor, battery.product,
                battery.iconName, battery.udi)

        if (isMouse(battery)) {
            return "icon://hardware/mouse"
        } else if (battery.type == Battery.PrimaryBattery) {
            return "icon://hardware/laptop"
        } else {
            return "icon://hardware/computer"
        }
    }

    function isMouse(battery) {
        return battery.type == Battery.MouseBattery ||
                battery.type == Battery.KeyboardMouseBattery ||
                battery.name.toLowerCase().indexOf("mouse") != -1 ||
                battery.product.toLowerCase().indexOf("mouse") != -1
    }

    function deviceChargeIcon(device) {
        var level = "full"

        if (!device)
            return "device/battery_unknown"

        print(device.chargePercent)

        if (device.chargePercent < 25)
            level = "20"
        else if (device.chargePercent < 35)
            level = "30"
        else if (device.chargePercent < 55)
            level = "50"
        else if (device.chargePercent < 65)
            level = "60"
        else if (device.chargePercent < 85)
            level = "80"
        else if (device.chargePercent < 95)
            level = "90"

        print(level, device.chargeState)

        if (device.chargeState == Battery.Charging ||
                device.chargeState == Battery.FullyCharged)
            return "device/battery_charging_" + level
        else
            return "device/battery_" + level
    }

    function deviceSummary(device) {
        var percent = device.chargePercent + "%"

        print("Battery state", device.chargeState)

        if (device.chargeState == Battery.Charging) {
            return "%1 until full".arg(DateUtils.shortDuration(device.timeToFull * 1000, 'm'))
        } else if (device.chargeState == Battery.Discharging && device.timeToEmpty != 0) {
            return "%1 remaining".arg(DateUtils.shortDuration(device.timeToEmpty * 1000, 'm'))
        } else if (device.chargeState == Battery.FullyCharged) {
            return "Fully Charged"
        } else {
            return percent
        }
    }
}
