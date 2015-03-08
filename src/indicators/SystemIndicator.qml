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
import ".."

Indicator {
    id: indicator

    width: iconsRow.width + units.dp(20)

    Row {
        id: iconsRow
        anchors.centerIn: parent

        spacing: units.dp(10)

        IndicatorIcon {
            name: "device/signal_wifi_3_bar"
            tooltip: "Wifi not connected"
        }

        IndicatorIcon {
            name: sound.iconName
            tooltip: "Volume at %1%".arg(sound.master)
        }

        IndicatorIcon {
            name: upower.deviceIcon(upower.primaryDevice)
            tooltip: upower.deviceSummary(upower.primaryDevice)
        }

        IndicatorIcon {
            // TODO: Use an appropriate Material Design icon
            name: "awesome/power_off"
        }
    }
}
