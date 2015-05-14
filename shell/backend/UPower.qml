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
import Material.Extras 0.1
import Papyros.Desktop 0.1

UPowerConnection {
    id: upower

    property var primaryDevice

    onDevicesChanged: reload()

    Component.onCompleted: reload()

    function reload() {
        print(devices, devices.length)
        for (var i = 0; i < devices.length; i++) {
            var device = devices[i]

            print(device.type, device.percentage)
            if (device.type == UPowerDeviceType.Battery) {
                primaryDevice = device
                return
            }
        }
    }

    function deviceIcon(device) {
        var level = "full"

        if (!device)
            return "device/battery_unknown"

        print(device.percentage)

        if (device.percentage < 25)
            level = "20"
        else if (device.percentage < 35)
            level = "30"
        else if (device.percentage < 55)
            level = "50"
        else if (device.percentage < 65)
            level = "60"
        else if (device.percentage < 85)
            level = "80"
        else if (device.percentage < 95)
            level = "90"

        print(level, device.state)

        if (device.state == UPowerDeviceState.Charging ||
                device.state == UPowerDeviceState.FullyCharged)
            return "device/battery_charging_" + level
        else
            return "device/battery_" + level
    }

    function deviceSummary(device) {
        var percent = device.percentage + "%"

        if (device.state == UPowerDeviceState.Charging) {
            return "%1 until full".arg(DateUtils.shortDuration(device.timeToFull * 1000, 'm'))
        } else if (device.state == UPowerDeviceState.Discharging && device.timeToEmpty != 0) {
            return "%1 remaining".arg(DateUtils.shortDuration(device.timeToEmpty * 1000, 'm'))
        } else if (device.state == UPowerDeviceState.FullyCharged) {
            return "Fully Charged"
        } else {
            return percent
        }
    }
}
