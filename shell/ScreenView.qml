/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 *
 * Copyright (C) 2016 Michael Spencer <sonrisesoftware@gmail.com>
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

import QtQuick 2.6
import QtQuick.Window 2.2
import GreenIsland 1.0

WaylandOutput {
    id: output

    property alias surfacesArea: backgroundLayer

    manufacturer: nativeScreen.manufacturer
    model: nativeScreen.model
    position: nativeScreen.position
    physicalSize: nativeScreen.physicalSize
    subpixel: nativeScreen.subpixel
    transform: nativeScreen.transform
    scaleFactor: nativeScreen.scaleFactor
    sizeFollowsWindow: true

    window: Window {
        property QtObject output

        id: window
        x: nativeScreen.position.x
        y: nativeScreen.position.y
        width: nativeScreen.size.width
        height: nativeScreen.size.height
        flags: Qt.FramelessWindowHint
        visible: false

        KeyBindingsFilter {
            anchors.fill: parent
            keyBindings: compositor.keyBindingsManager
        }

        LocalPointerTracker {
            id: localPointerTracker
            anchors.fill: parent
            globalTracker: globalPointerTracker

            Image {
                id: backgroundLayer
                anchors.fill: parent
                source: "images/wallpaper.png"
                sourceSize.width: width
                sourceSize.height: height
                fillMode: Image.Tile
            }

            PointerItem {
                id: cursor
                inputDevice: output.compositor.defaultInputDevice
                x: localPointerTracker.mouseX - hotspotX
                y: localPointerTracker.mouseY - hotspotY
                visible: globalPointerTracker.output === output
            }
        }
    }
}
