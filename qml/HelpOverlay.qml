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
import QtQuick 2.4
import Material 0.1

View {
    anchors.centerIn: parent

    width: units.dp(500)
    height: units.dp(350)
    elevation: 2
    radius: units.dp(2)

    opacity: shell.state == "help" ? 1 : 0

    Behavior on opacity {
        NumberAnimation {
            duration: 250
        }
    }

    property var shortcuts: {
        "Super": "Open the App Launcher",
        "Super+S": "Spread workspaces",
        "Super+D": "Display the dashboard",
        "Super+L": "Lock your " + Device.name,
        "Super+?": "Display this help overlay"
    }

    Item {
        id: actionBar
        height: units.dp(64)

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            leftMargin: units.dp(20)
            rightMargin: units.dp(20)
        }

        IconAction {
            id: closeIcon

            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            name: "navigation/close"
            onTriggered: shell.toggleHelp()
        }

        Label {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }

            text: "Keyboard Shortcuts"
            style: "title"
            color: Theme.light.iconColor
        }
    }

    Column {
        anchors {
            left: parent.left
            right: parent.right
            top: actionBar.bottom
            bottom: parent.bottom
            margins: units.dp(20)
        }

        spacing: units.dp(16)

        Repeater {
            model: Object.keys(shortcuts)
            delegate: Row {
                width: parent.width

                property var keys: modelData.split('+')

                Row {
                    id: row

                    Repeater {
                        model: keys.length * 2 - 1

                        delegate: KeyLabel {
                            text: index % 2 == 0 ? keys[index/2] : "+"
                            showBorder: index % 2 == 0
                        }
                    }

                    width: units.dp(100)

                    anchors.verticalCenter: parent.verticalCenter
                }

                Label {
                    width: parent.width - row.width
                    text: shortcuts[modelData]
                    style: "subheading"

                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
