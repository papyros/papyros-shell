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
import ".."

Indicator {
    id: indicator

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

    }

    BatteryInfo {
        id: batteryInfo
    }
}
