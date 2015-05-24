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
import Material 0.1

View {
    id: indicators

    anchors {
        right: parent.right
        bottom: parent.bottom
        margins: Units.dp(20)
    }

    width: row.width + Units.dp(32)
    height: row.height + Units.dp(20)

    radius: Units.dp(2)
    elevation: 2

    Row {
        id: row

        anchors.centerIn: parent

        spacing: Units.dp(16)

        Label {
            text: Qt.formatTime(now)
            font.pixelSize: Units.dp(16)
            anchors.verticalCenter: parent.verticalCenter
        }

        Icon {
            name: sound.iconName
            size: Units.dp(20)
        }

        Icon {
            name: upower.deviceIcon(upower.primaryDevice)
            size: Units.dp(20)
        }

        Icon {
            name: "awesome/power_off"
            size: Units.dp(20)
            color: "gray"
        }
    }
}
