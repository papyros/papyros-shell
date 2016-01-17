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
import QtQuick 2.3
import Material 0.2
import Papyros.Desktop 0.1

import "../../components"

/*
* The Panel is the top panel with the status icons on the right and the Papyros icon and active app info on the left.
*/
Item {
    anchors {
        bottomMargin: Units.dp(3)
        bottom: parent.bottom
        horizontalCenter: parent.horizontalCenter
    }

    height: Units.dp(64)
    width: row.width

    Rectangle {
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            leftMargin: Units.dp(-3)
            rightMargin: Units.dp(-3)
            bottomMargin: Units.dp(-8)
        }

        radius: Units.dp(3)
        height: Units.dp(8)
    }

    Row {
        id: row
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        Item {
            width: parent.height
            height: width

            ActionButton {
                anchors.centerIn: parent
                width: parent.height * 0.6
                height: width
                //radius: width/2
                backgroundColor: "white"

                // Ink {
                //     anchors.fill: parent
                //     circular: true
                //     centered: true
                // }

                Grid {
                    anchors.centerIn: parent
                    columns: 3
                    columnSpacing: Units.dp(3)
                    rowSpacing: Units.dp(3)
                    Repeater {
                        model: 6
                        Rectangle {
                            color: Theme.light.iconColor
                            width: Units.dp(5)
                            height: width
                            radius: width/2
                        }
                    }
                }
            }
        }

        Repeater {
            model: [
                    "papyros-files", "epiphany", "geary", "gnome-dictionary",
                    "gnome-control-center"]
            delegate: Ink {
                width: parent.height
                height: width

                DesktopFile {
                    id: desktopFile
                    appId: modelData
                }

                AppIcon {
                    iconName: desktopFile.iconName
                    name: desktopFile.name
                    anchors.centerIn: parent
                    width: parent.width * 0.75
                    height: width
                }

                onClicked: desktopFile.launch()
            }
        }
    }
}
