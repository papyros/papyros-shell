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
import QtQuick 2.0
import Material 0.1
import Material.ListItems 0.1 as ListItem
import Papyros.Indicators 0.1

Indicator {
    id: indicator

    iconName: "hardware/desktop_windows"
    tooltip: "Session"

    view: Column {

        Repeater {
            model: sessionModel
            delegate: ListItem.Standard {
                text: name
                selected: index == selectedSession

                onClicked: {
                    selectedSession = index
                    indicator.close()
                }

                Icon {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: Units.dp(16)
                    }

                    name: "navigation/check"
                    visible: selected
                    color: Theme.primaryColor
                }
            }
        }
    }
}
