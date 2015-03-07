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
	   	height: units.dp(90)

		Image {
			anchors {
				horizontalCenter: parent.horizontalCenter
				top: parent.top
				topMargin: units.dp(1)
			}
			height: units.dp(40)
			width: units.dp(40)
			source: edit.icon
		}
		Ink {
			anchors.fill: parent
			onClicked: edit.launch()
		}
		Label {
			text: edit.localizedName || edit.name
			anchors.bottom: parent.bottom
			anchors.bottomMargin: units.dp(0.5)
			width: parent.width
			wrapMode: Text.WordWrap
			horizontalAlignment: Text.AlignHCenter
		}
	}
        cellWidth: units.dp(90)
	cellHeight: units.dp(90)
}
