/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 * Copyright (C) 2015 Michael Spencer
 *               2015 Bogdan Cuza
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
import Material.Desktop 0.1

import ".."
import "../components"
import "../panel/indicators"

Indicator {
    id: appDrawer

    function gotoIndex(idx) {
        anim.running = false
        var pos = mainLoader.item.contentY;
        var destPos;
        mainLoader.item.positionViewAtIndex(idx, ListView.Beginning);
        destPos = mainLoader.item.contentY;
        anim.from = pos;
        anim.to = destPos;
        anim.running = true;
    }

    icon: config.layout == "classic" ? "navigation/apps" : ""
    iconSize: units.dp(24)
    tooltip: "Applications"
    text: config.layout == "classic" ? "" : "Applications"
    width:  text ? label.width + (units.dp(40) - label.height)  : height

    dropdown: DropDown {
        height: units.dp(360)

        Component.onCompleted: {
            if (config.layout == "classic")
                width = height;
        }

        Rectangle {
            id: container

            z: 10
            width: parent.width
            height: input.height
            color: "white"

            TextField {
                id: input

                placeholderText: "Search"
            	anchors {
            	    left: parent.left
            	    right: parent.right
            	    leftMargin: units.dp(10)
            	    rightMargin: units.dp(10)
            	}

                onTextChanged: {
                    var possibleIndex = desktopScrobbler.getIndexByName(text);
                    if (possibleIndex == -1) {
                        return;
                    } else {
                        gotoIndex(possibleIndex);
                    }
                }
            }
        }

        Loader {
            id: mainLoader

            anchors {
                left: parent.left
                right: parent.right
                top: container.bottom
                bottom: parent.bottom
            }

            source: Qt.resolvedUrl("Use" + (config.layout == "classic" ? "List" : "Grid") + ".qml")
        }
    }

    NumberAnimation { id: anim; target: mainLoader.item; property: "contentY"; duration: 500 }
    Connections {
        target: shell

        onSuperPressed: selected ? selectedIndicator = null
                                 : selectedIndicator = appDrawer
    }

    DesktopScrobbler {
        id: desktopScrobbler
    }
}
