/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 * Copyright (C) 2015 Bogdan Cuza
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

GridView {
    z: 5
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    model: desktopScrobbler.desktopFiles
    delegate: Item {
        width: units.dp(90)
        height: units.dp(70)

        Image {
            id: icon

	    anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: units.dp(1)
            }
            height: units.dp(50)
            width: units.dp(50)
            source: edit.icon || "/usr/share/icons/HighContrast/256x256/mimetypes/application-x-executable.png" //placeholder, needs to be replaced with something smarter than a static url
        }
        Ink {
            anchors.fill: parent
            onClicked: edit.launch()
        }
        Label {
            text: edit.localizedName || edit.name
            width: parent.width
            elide: Text.ElideRight
            anchors {
                top: icon.bottom
                bottom: parent.bottom
                bottomMargin: units.dp(0.5)
            }
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: Text.AlignHCenter
        }
    }
    cellWidth: units.dp(90)
    cellHeight: units.dp(70)
}
