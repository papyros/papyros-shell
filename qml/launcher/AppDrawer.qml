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
import Material.ListItems 0.1 as ListItem

import ".."
import "../components"
import "../panel/indicators"

Indicator {
    id: appDrawer

    icon: config.layout == "classic" ? "navigation/apps" : ""
    iconSize: units.dp(24)
    tooltip: "Applications"

    text: config.layout == "classic" ? "" : "Applications"

    width:  text ? label.width + (units.dp(40) - label.height)  : height

    dropdown: DropDown {
        id: dropdown

        height: units.dp(360)

        Rectangle {
        	id: fieldContainer

        	color: "white"
        	height: searchField.height
        	anchors {
        		left: parent.left
        		right: parent.right
        		top: parent.top
        		topMargin: units.dp(5)
        		margins: units.dp(15)
        	}
        	z: 10

        	TextField {
	            id: searchField

	            placeholderText: "Search..."
	        }
        }

        ListView {
        	z: 5
            anchors {
                left: parent.left
                right: parent.right
                top: fieldContainer.bottom
                bottom: parent.bottom
            }
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            model: desktopScrobbler.desktopFiles
            delegate: ListItem.Subtitled {
                onTriggered: ProcessHelper.startDetached(edit.exec)
                text: edit.localizedName || edit.name
                subText: edit.localizedComment || edit.comment
            }
        }
    }

    Connections {
        target: shell

        onSuperPressed: selected ? selectedIndicator = null
                                 : selectedIndicator = appDrawer
    }
    DesktopScrobbler {
        id: desktopScrobbler
    }
}
