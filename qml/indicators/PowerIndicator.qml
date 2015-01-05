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
import Material.ListItems 0.1 as ListItem
import Material.Desktop 0.1
import Material.Extras 0.1
import ".."

Indicator {
    id: indicator

    tooltip: {
        if (!primaryPowerSource)
            return "Unknown"

        var percent = primaryPowerSource.percentage + "%"

        if (primaryPowerSource.state == UPowerDeviceState.Charging) {
            return "%1 until full (%2)".arg(DateUtils.friendlyDuration(primaryPowerSource.timeToFull * 1000, 'm')).arg(percent)
        } else if (primaryPowerSource.state == UPowerDeviceState.Discharging) {
            return "%1 remaining (%2)".arg(DateUtils.friendlyDuration(primaryPowerSource.timeToEmpty * 1000, 'm')).arg(percent)
        } else if (primaryPowerSource.state == UPowerDeviceState.FullyCharged) {
            return "Fully Charged"
        } else {
            return percent
        }
    }

    icon: {
        var level = "full"

        if (!primaryPowerSource)
            return "device/battery_unknown"

        print(primaryPowerSource.percentage)

        if (primaryPowerSource.percentage < 25)
            level = "20"
        else if (primaryPowerSource.percentage < 35)
            level = "30"
        else if (primaryPowerSource.percentage < 55)
            level = "50"
        else if (primaryPowerSource.percentage < 65)
            level = "60"
        else if (primaryPowerSource.percentage < 85)
            level = "80"
        else if (primaryPowerSource.percentage < 95)
            level = "90"

        print(level, primaryPowerSource.state)

        if (primaryPowerSource.state == UPowerDeviceState.Charging ||
                primaryPowerSource.state == UPowerDeviceState.FullyCharged)
            return "device/battery_charging_" + level
        else
            return "device/battery_" + level
    }

    dropdown: DropDown {

    }

    property var primaryPowerSource

    UPowerConnection {
        id: upower

        onDevicesChanged: reload()

        Component.onCompleted: reload()

        function reload() {
            print(devices, devices.length)
            for (var i = 0; i < devices.length; i++) {
                var device = devices[i]

                print(device.type, device.percentage)
                if (device.type == UPowerDeviceType.Battery) {
                    primaryPowerSource = device
                }
            }
        }
    }
}
