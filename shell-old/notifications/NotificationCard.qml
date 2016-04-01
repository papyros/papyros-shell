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
import QtQuick.Layouts 1.0
import Material 0.1

View {
    id: card

    property bool showing: mouseArea.containsMouse

    property var notification

    radius: Units.dp(2)
    elevation: 3

    clipContent: false

    width: parent.width
    height: subLabel.lineCount == 1  ? Units.dp(72) : Units.dp(88)

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        anchors.margins: -Units.dp(10)
        hoverEnabled: true

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left

            width: Units.dp(30)
            height: width
            radius: width/2

            color: "#333"

            opacity: mouseArea.containsMouse ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 250 }
            }

            IconButton {
                iconName: "navigation/close"
                anchors.centerIn: parent
                color: "white"
                size: Units.dp(16)

                onClicked: {
                    print("Closing...")
                    notifyServer.closeNotification(notification.hasOwnProperty("id")
                            ? notification.id : notification.notificationId)
                }
            }
        }
    }

    GridLayout {
        anchors.fill: parent

        anchors.leftMargin: Units.dp(16)
        anchors.rightMargin: Units.dp(16)

        columns: 4
        rows: 1
        columnSpacing: Units.dp(16)

        Item {
            id: actionItem

            Layout.preferredWidth: Units.dp(40)
            Layout.preferredHeight: width
            Layout.alignment: Qt.AlignCenter
            Layout.column: 1

            visible: children.length > 1 || icon.valid

            Icon {
                id: icon

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                }

                visible: valid
                color: Theme.light.iconColor
                size: Units.dp(24)
                source: {
                    print(notification.iconName)
                    if (!notification.iconName) {
                        return ""
                    } else if (notification.iconName.indexOf("/") === 0 || notification.iconName.indexOf("://") !== -1) {
                        return notification.iconName
                    } else {
                        return "image://desktoptheme/" + notification.iconName
                    }
                }
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.column: 2

            spacing: Units.dp(3)

            RowLayout {
                Layout.fillWidth: true

                spacing: Units.dp(8)

                Label {
                    id: label

                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true

                    elide: Text.ElideRight
                    style: "subheading"
                    text: notification.summary
                }

                Label {
                    id: valueLabel

                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: visible ? implicitWidth : 0

                    color: Theme.light.subTextColor
                    elide: Text.ElideRight
                    horizontalAlignment: Qt.AlignHCenter
                    style: "body1"
                    visible: text != ""
                }
            }

            Item {
                id: contentItem

                Layout.fillWidth: true

                visible: children.length > 0
                height: visible ? subLabel.implicitHeight : 0
            }

            Label {
                id: subLabel

                Layout.fillWidth: true

                color: Theme.light.subTextColor
                elide: Text.ElideRight
                wrapMode: Text.WordWrap
                style: "body1"

                visible: text != "" && !contentItem.visible
                text: "~~"  + notification.body + "~~"
                maximumLineCount: 2
            }
        }

        Item {
            id: secondaryItem
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: childrenRect.width
            Layout.preferredHeight: parent.height
            Layout.column: 4

            visible: childrenRect.width > 0
        }
    }
}
