/*
 * Quartz Shell - The desktop shell for Quartz OS following Material Design
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
import Material 0.1

DropDown {

    implicitWidth: units.dp(400)
    implicitHeight: units.dp(300)

    Column {
        id: iconsColumn

        width: units.dp(50)

        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        Repeater {
            model: [
                {
                    icon: "communication/chat",
                    description: "Chat"
                },
                {
                    icon: "content/content_paste",
                    description: "Clipboard manager"
                },
                {
                    icon: "navigation/fullscreen",
                    description: "Screen clip/quick note (i.e., Evernote)",
                    size: units.dp(30)
                }
            ]

            delegate: Item {
                width: parent.width
                height: width

                Icon {
                    name: modelData.icon
                    size: modelData.size ? modelData.size : units.dp(24)
                    anchors.centerIn: parent
                }

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.right
                    anchors.leftMargin: units.dp(10)
                    text: modelData.description
                }
            }
        }
    }

    Rectangle {
        width: 1

        anchors {
            left: iconsColumn.right
            top: parent.top
            bottom: parent.bottom
        }

        color: theme.blackColor('divider')
    }
}
