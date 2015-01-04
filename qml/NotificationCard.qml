/*
 * Quantum Shell - The desktop shell for Quantum OS following Material Design
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
import QtQuick 2.3
import Material 0.1

View {
    id: card

    property bool showing: mouseArea.containsMouse

    property var notification

    radius: units.dp(2)
    elevation: 3

    clipContent: false

    width: parent.width
    height: units.dp(80)

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        anchors.margins: -units.dp(10)
        hoverEnabled: true

        Rectangle {
            anchors.top: parent.top
            anchors.right: parent.right

            width: units.dp(30)
            height: width
            radius: width/2

            color: "#333"

            opacity: mouseArea.containsMouse ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 250 }
            }

            IconAction {
                name: "navigation/close"
                anchors.centerIn: parent
                color: "white"
                size: units.dp(16)

                onTriggered: {
                    print("Closing...")
                    notifyServer.closeNotification(notification.id)
                }
            }
        }
    }

    Column {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: units.dp(16)

        spacing: units.dp(8)

        Label {
            style: "subheading"
            text: notification.summary
            elide: Text.ElideRight
            width: parent.width
        }

        Label {
            style: "body1"
            text: notification.body
            elide: Text.ElideRight
            width: parent.width
            maximumLineCount: 1
        }
    }
}
