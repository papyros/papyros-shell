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
import "../components"

GridView {
    z: 5
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    model: desktopScrobbler.desktopFiles
    delegate: Item {
        width: Units.dp(100)
        height: Units.dp(100)

        Ink {
            anchors.fill: parent
            onClicked: {
                edit.launch()
                desktop.overlayLayer.currentOverlay.close()
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: Units.dp(8)
            width: parent.width - Units.dp(16)

            AppIcon {
                anchors.horizontalCenter: parent.horizontalCenter
                height: Units.dp(40)
                width: Units.dp(40)
                iconName: edit.iconName
                name: edit.name
            }

            Label {
                text: edit.name
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
       
    cellWidth: Units.dp(100)
    cellHeight: Units.dp(100)
}
