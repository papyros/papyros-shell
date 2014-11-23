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

View {
    id: notification

    property bool showing: mouseArea.containsMouse

    radius: units.dp(2)
    elevation: 3

    clip: false

    anchors {
        right: parent.right
        rightMargin: showing ? units.dp(20) : units.dp(20) - notification.width

        Behavior on rightMargin {
            NumberAnimation { duration: 200 }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        anchors.margins: -units.dp(20)
        hoverEnabled: true
    }
}
