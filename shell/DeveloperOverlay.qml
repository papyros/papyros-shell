/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
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
import QtQuick 2.4
import Material 0.2

View {
    anchors.centerIn: parent

    width: Units.dp(500)
    height: Units.dp(350)
    elevation: 2
    radius: Units.dp(2)

    opacity: shell.state == "developer" ? 1 : 0
    visible: opacity > 0

    Behavior on opacity {
        NumberAnimation {
            duration: 250
        }
    }

    Item {
        id: actionBar
        height: Units.dp(64)

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            leftMargin: Units.dp(20)
            rightMargin: Units.dp(20)
        }

        IconButton {
            id: closeIcon

            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            iconName: "navigation/close"
            onClicked: shell.toggleDeveloperTools()
        }

        Label {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }

            text: "Developer Tools"
            style: "title"
            color: Theme.light.iconColor
        }
    }

    TextEdit {
        anchors {
            left: parent.left
            right: parent.right
            top: actionBar.bottom
            bottom: parent.bottom
            margins: Units.dp(20)
        }

        readOnly: true
        text: shell.logs
    }
}
