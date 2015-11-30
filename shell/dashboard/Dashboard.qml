/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
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
import QtQuick 2.4
import Material 0.1
import Material.Extras 0.1

Rectangle {
    id: dashboard

    anchors.fill: parent

    color: "#fafafa"

    opacity: shell.state == "dashboard" ? 1 : 0

    Behavior on opacity {
        NumberAnimation {
            duration: 250
        }
    }

    Item {
        height: childrenRect.height

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: Units.dp(20)
        }

        IconButton {
            id: backIcon

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }

            iconName: "navigation/arrow_back"
            onClicked: shell.toggleDashboard()
        }

        Label {
            anchors {
                left: backIcon.right
                leftMargin: Units.dp(20)
                verticalCenter: parent.verticalCenter
            }

            text: "Papyros"
            style: "title"
            color: Theme.light.iconColor
        }

        Row {
            id: row

            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            spacing: Units.dp(20)

            Label {
                text: Qt.formatTime(now)
                color: Theme.light.iconColor
                font.pixelSize: Units.dp(16)
                anchors.verticalCenter: parent.verticalCenter
            }

            Icon {
                name: "device/signal_wifi_3_bar"
                size: Units.dp(20)
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
}
