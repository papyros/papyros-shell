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
import Material 0.2
import Material.Extras 0.1
import Material.ListItems 0.1 as ListItem

Indicator {
    id: indicator

    iconName: "navigation/expand_more"
    tooltip: "Action Center"

    visible: hiddenIndicators.length > 0
    userSensitive: true

    property Indicator selectedView: visible ? hiddenIndicators[0] : null

    property var hiddenIndicators: ListUtils.filter(indicators, function(modelData) {
        return modelData.hidden && modelData.visible && modelData != indicator
    })

    view: Item {
        implicitHeight: width
        implicitWidth: Units.dp(350)

        Column {
            id: iconsColumn

            width: Units.dp(50)

            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }

            Repeater {
                model: hiddenIndicators

                delegate: Item {
                    width: parent.width
                    height: width

                    Icon {
                        name: modelData.iconName
                        size: Units.dp(24)
                        color: selectedView == modelData
                                ? Theme.light.accentColor : Theme.light.textColor
                        anchors.centerIn: parent
                    }

                    Ink {
                        anchors.fill: parent
                        onClicked: selectedView = modelData
                    }
                }
            }
        }

        Rectangle {
            id: divider
            width: Units.dp(1)

            anchors {
                left: iconsColumn.right
                top: parent.top
                bottom: parent.bottom
            }

            color: Theme.light.dividerColor
        }

        Loader {
            id: loader

            anchors {
                left: divider.right
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }

            sourceComponent: selectedView ? selectedView.view : undefined
        }
    }
}
