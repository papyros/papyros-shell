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
import QtQuick 2.0
import Material 0.1
import Material.ListItems 0.1 as ListItem
import ".."

Indicator {
    id: indicator

    icon: "av/loop"
    tooltip: "Ongoing Operations"

    showing: operations.length > 0
    userSensitive: true

    // TODO: Where does this come from?
    property var operations: [
        {
            icon: "action/settings",
            title: "System update",
            progress: 0.56
        },
        {
            icon: "file/file_download",
            title: "Mockups.zip",
            progress: 0.4
        }
    ]

    onSelectedChanged: {
        if (selected) {
            dropdown.open(indicator)
        } else {
            dropdown.close()
        }
    }

    DropDown {
        id: dropdown

        implicitHeight:  column.height

        Column {
            id: column
            width: parent.width

            Repeater {
                model: indicator.operations
                delegate: ProgressListItem {
                    action: Rectangle {
                        anchors.fill: parent
                        color: modelData.color ? modelData.color : "gray"
                        radius: width/2
                        Icon {
                            anchors.centerIn: parent
                            //anchors.horizontalCenterOffset: units.gu(0.1)
                            size: units.dp(27)
                            name: modelData.icon
                            color: "white"
                        }
                    }

                    text: modelData.title
                    valueText: "%1%".arg(modelData.progress * 100)
                    progress: modelData.progress
                }
            }
        }
    }
}
