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
import QtQuick 2.3
import Material 0.1
import "indicators"

/*
 * The Panel is the top panel with the status icons on the right and the Quartz icon and active app info on the left.
 */
Rectangle {
    id: panel

    property bool raised: true
    property alias indicators: indicatorsRow.children
    property Indicator selectedIndicator

    color: Qt.rgba(55/256, 71/256, 79/256, screenLocked ? 0.5 : 0.9)
    height: units.dp(48)

    anchors {
        left: parent.left
        right: parent.right
        top: parent.top
    }

    Behavior on color {
        ColorAnimation {
            duration: 500
        }
    }

    // The left side of the panel. Contains the Quartz Logo (and hotcorner), along with the active window's controls
    Row {
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        Item {
            width: height
            height: parent.height

            Image {
                anchors {
                    fill: parent
                    margins: units.dp(7.5)
                }

                source: Qt.resolvedUrl("images/quartz-os.png")
                mipmap: true // FIXME: Get an appropriately sized image and remove this
            }
        }

        Item {
            width: units.dp(10)
            height: parent.height
        }

        Item {
            width: height
            height: parent.height

            Image {
                anchors {
                    fill: parent
                    margins: units.dp(10)
                }

                source: currentWindow.icon
                mipmap: true // FIXME: Get an appropriately sized image and remove this
            }
        }

        Item {
            width: units.dp(6)
            height: parent.height
        }

        Label {
            text: currentWindow.appName
            style: "subheading"
            color: "white"

            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // The right side of the panel. Contains the Information Center (battery, volume, networking, etc)
    // TODO: Load indicators from separate files, and only show them when necessary
    Row {
        id: indicatorsRow

        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }

//        Indicator {
//            icon: "content/create"
//            tooltip: "Quick Actions"
//        }

        OperationsIndicator {}

        Indicator {
            icon: "file/cloud_done"
            tooltip: "Cloud services"

            userSensitive: true
        }

        Indicator {
            icon: "social/notifications_none"
            tooltip: "Notifications"

            userSensitive: true
        }

        Indicator {
            icon: "device/signal_wifi_3_bar"
            tooltip: "Network"
        }

        Indicator {
            icon: "av/volume_up"
            tooltip: "Volume"
        }

        PowerIndicator {}

        ActionCenterIndicator {}

        DateTimeIndicator {}

        Indicator {
            icon: "action/account_circle"
            tooltip: "System"

            userSensitive: true
        }
    }

    // This is necessary to get the shadow affect and still have the panel be translucent
    Item {

        height: parent.height
        visible: panel.raised
        clip: true

        opacity: screenLocked ? 0 : 1

        Behavior on opacity {
            NumberAnimation {
                duration: 500
            }
        }

        anchors {
            left: parent.left
            right: parent.right
            top: parent.bottom
        }

        View {

            height: panel.height
            fullWidth: true
            elevation: 3

            anchors {
                top: parent.top
                topMargin: -panel.height
                left: parent.left
                right: parent.right
            }
        }
    }
}
