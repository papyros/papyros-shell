/*
* Papyros SDDM theme - The SDDM theme for Papyros following Material Design
* Copyright (C) 2015 Michael Spencer <sonrisesoftware@gmail.com>
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
import Material 0.3
import Papyros.Indicators 0.1

View {
    id: indicatorRows

    property list<Indicator> indicators: [
        DateTimeIndicator {},
        KeyboardIndicator {},
        SessionIndicator {},
        NetworkIndicator {},
        SoundIndicator {},
        BatteryIndicator {},
        PowerIndicator {}
    ]

    anchors {
        right: parent.right
        bottom: parent.bottom
        margins: Units.dp(16)
    }

    width: row.width + Units.dp(24)
    height: Units.dp(48)

    radius: Units.dp(2)
    elevation: 2

    Row {
        id: row

        anchors.centerIn: parent
        height: parent.height

        Repeater {
            model: indicators
            delegate: IndicatorView {
                indicator: modelData
                defaultColor: Theme.light.iconColor
                defaultTextColor: Theme.light.textColor
                visible: !indicator.userSensitive && indicator.visible
            }
        }
    }
}
