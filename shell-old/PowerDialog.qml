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
import QtQuick 2.2
import QtQuick.Window 2.0
import Material 0.1
import Material.ListItems 0.1 as ListItem
import Material.Extras 0.1
import Papyros.Desktop 0.1

PopupBase {
    id: dialog

    overlayLayer: "dialogOverlayLayer"
    overlayColor: Qt.rgba(0, 0, 0, 0.5)

    opacity: showing ? 1 : 0
    visible: opacity > 0

    width: Units.dp(300)
    height: column.implicitHeight

    anchors {
        centerIn: parent
        verticalCenterOffset: showing ? 0 : -(dialog.height/3)

        Behavior on verticalCenterOffset {
            NumberAnimation { duration: 200 }
        }
    }

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Escape) {
            closeKeyPressed(event)
        }
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Back) {
            closeKeyPressed(event)
        }
    }

    onShowingChanged: {
        if (showing) {
            startTime = new Date()
            remainingSeconds = totalSeconds
        }
    }

    function closeKeyPressed(event) {
        if (dialog.showing) {
            if (dialog.dismissOnTap) {
                dialog.close()
            }
            event.accepted = true
        }
    }

    property var startTime
    property int remainingSeconds
    property int totalSeconds: 60

    Timer {
        running: showing
        interval: 1000
        repeat: true
        onTriggered: {
            remainingSeconds = totalSeconds - (new Date() - startTime)/1000
        }
    }

    Timer {
        running: showing
        interval: totalSeconds * 1000
        onTriggered: {
            dialog.close()
            SessionManager.powerOff()
        }
    }

    View {
        id: dialogContainer

        anchors.fill: parent
        elevation: 5
        radius: Units.dp(2)

        Column {
            id: column
            anchors.fill: parent

            Rectangle {
                radius: Units.dp(2)
                color: Palette.colors['red']['500']

                width: parent.width
                height: width * 3/5

                Rectangle {
                    height: parent.height/2
                    color: parent.color

                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.right
                    }
                }

                Column {
                    anchors.centerIn: parent
                    spacing: Units.dp(4)
                    Icon {
                        anchors.horizontalCenter: parent.horizontalCenter
                        name: "action/power_settings_new"
                        size: Units.dp(36)
                        color: Theme.dark.iconColor
                    }
                    Item {
                        width: parent.width
                        height: Units.dp(8)
                    }
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        style: "title"
                        color: Theme.dark.textColor
                        text: "Power Off"
                    }
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        style: "subheading"
                        color: Theme.dark.subTextColor
                        horizontalAlignment: Qt.AlignHCenter
                        text: ("The system will power off\nautomatically in %1 " +
                              "seconds.").arg(remainingSeconds)
                    }
                }
            }

            Item {
                width: parent.width
                height: Units.dp(8)
            }

            ListItem.Standard {
                iconSource: Qt.resolvedUrl("images/sleep.svg")
                text: "Sleep"
                visible: SessionManager.canSuspend
                onClicked: {
                    dialog.close()
                    SessionManager.suspend()
                }
            }

            ListItem.Standard {
                iconName: "file/file_download"
                text: "Suspend to disk"
                visible: SessionManager.canHibernate
                onClicked: {
                    dialog.close()
                    SessionManager.hibernate()
                }
            }

            ListItem.Standard {
                iconName: "action/power_settings_new"
                text: "Power off"
                visible: SessionManager.canPowerOff
                onClicked: {
                    dialog.close()
                    SessionManager.powerOff()
                }
            }

            ListItem.Standard {
                iconSource: Qt.resolvedUrl("images/reload.svg")
                text: "Restart"
                visible: SessionManager.canRestart
                onClicked: {
                    dialog.close()
                    SessionManager.restart()
                }
            }

            Item {
                width: parent.width
                height: Units.dp(8)
            }
        }
    }
}
