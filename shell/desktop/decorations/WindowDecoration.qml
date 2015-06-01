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
import QtQuick.Layouts 1.0
import Material 0.1
import Material.Extras 0.1
import GreenIsland.Desktop 1.0 as Desktop

Desktop.WindowDecoration {
    id: decoration

    container: container

    property list<Action> windowActions: [
        Action {
            iconSource: Qt.resolvedUrl("../../images/window-minimize.svg")
            onTriggered: clientWindow.minimize()
        },
        Action {
            iconSource: clientWindow.maximized ? Qt.resolvedUrl("../../images/window-restore.svg")
                                               : Qt.resolvedUrl("../../images/window-maximize.svg")
            onTriggered: {
                if (clientWindow.maximized) {
                    clientWindow.unmaximize()
                } else {
                    clientWindow.maximize(_greenisland_output)
                }
            }
        },
        Action {
            iconName: "navigation/close"
            onTriggered: clientWindow.close()
        }
    ]

    View {
        anchors.fill: parent

        elevation: 5
    }

    Rectangle {
        id: windowBar

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        height: Units.dp(32)

        color: Palette.colors.blue["700"]

        Label {
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: Units.dp(16)
            }

            text: clientWindow.title
            color: Theme.dark.subTextColor
            style: "body2"
            font.bold: true
        }

        Row {
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
                rightMargin: Units.dp(8)
            }

            Repeater {
                model: windowActions

                delegate: View {
                    id: item

                    height: parent.height
                    width: height

                    tintColor: ink.containsMouse ? Qt.rgba(0,0,0,0.1) : Qt.rgba(0,0,0,0)

                    Ink {
                        id: ink

                        anchors.fill: parent
                        onClicked: modelData.triggered(item)
                    }

                    Icon {
                        size: Units.dp(16)
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: source.indexOf("minimize") != -1
                                ? Units.dp(4) : 0
                        source: modelData.iconSource
                        color: Theme.dark.subTextColor
                    }
                }
            }
        }
    }

    Item {
        id: container

        anchors {
            left: parent.left
            right: parent.right
            top: windowBar.bottom
            bottom: parent.bottom
        }
    }
 }
