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
    id: appDrawer

    icon: "navigation/apps"
    tooltip: "Applications"

    userSensitive: true

    dropdown: DropDown {
        id: dropdown

        implicitHeight: units.dp(200)

        TextField {
        	anchors {
        		left: parent.left
        		right: parent.right
        		top: parent.top
        		topMargin: units.dp(5)
        		margins: units.dp(15)
        	}

        	hintText: "Search..."
        }
    }
}
