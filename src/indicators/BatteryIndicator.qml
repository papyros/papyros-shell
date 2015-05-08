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
import Material.Desktop 0.1
import Material.ListItems 0.1 as ListItem

Indicator {
    id: indicator

    iconName: upower.deviceIcon(upower.primaryDevice)
    tooltip: upower.deviceSummary(upower.primaryDevice)
    color: upower.primaryDevice.percentage < 10 &&
            upower.primaryDevice.state != UPowerDeviceState.Charging
            ? Palette.colors.red["500"] : Theme.dark.iconColor

    view: Column {
        ListItem.Subtitled {
            text: "Screen Brightness"
            valueText: "25%"
            content: Slider {
                width: parent.width
                value: 0.25
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: Units.dp(7)
            }

            showDivider: true
        }

        Repeater {
            model: upower
            delegate: ListItem.Subtitled {
                text: deviceName
            }
        }
    }
}
