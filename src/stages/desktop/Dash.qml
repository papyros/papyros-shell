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
import QtQuick 2.3
import Material 0.1

import "../../components"

/*
* The Panel is the top panel with the status icons on the right and the Quantum icon and active app info on the left.
*/
Item {
    width: units.dp(500)
    height: units.dp(400)

    clip: true

    property bool showing

    Rectangle {
        color: Qt.rgba(1, 1, 1, 0.9)
        radius: units.dp(5)

        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            leftMargin: showing ? -radius : -width
            topMargin: -radius

            Behavior on leftMargin {
                NumberAnimation { duration: 200 }
            }
        }

        width: parent.width + radius
    }
}
