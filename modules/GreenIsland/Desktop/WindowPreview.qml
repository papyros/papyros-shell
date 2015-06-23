/*
 * This file is part of Green Island
 *
 * Copyright (C) 2015 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
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
import GreenIsland 1.0

Item {
	property url iconSource: window ? windowManager.sourceForIconName(window.iconName) : ""

	implicitWidth: height * windowManager.width / windowManager.height

	property real windowScale: {
		var widthScale = width/item.width
		var heightScale = height/item.height

		return Math.min(widthScale, heightScale)
	}

	property bool isActive: windowManager.activeWindow == item

	function activate() {
		windowManager.moveFront(item)
	}

 	SurfaceRenderer {
        anchors.centerIn: parent

        width: item ? item.width * windowScale : 0
        height: item ? item.height * windowScale : 0

        source: item ? item.child : null
    }
}