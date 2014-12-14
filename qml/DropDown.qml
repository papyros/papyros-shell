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

View {
    id: popover

    property bool showing
    property Item caller
    property int offset
    property var padding: units.dp(20)
    property var side

    function open(widget) {
        openAt(widget, popover.width/2, widget.height/2 + padding)
    }

    function close() {
        showing = false
    }

    function openAt(widget, x, y) {
        if (!widget)
            throw "Caller cannot be undefined!"

        caller = widget
        popover.parent = overlayLayer

        var position = widget.mapToItem(popover.parent, x, y)
        popover.x = position.x - popover.width/2

        if (position.y + popover.height + padding > overlayLayer.height) {
            side = Qt.AlignTop
            popover.y = position.y - popover.height - padding - widget.height
            if (position.y - popover.height - widget.height - padding < units.gu(1.5)) {
                popover.y = padding
                side = Qt.AlignVCenter
            }
        } else {
            side = Qt.AlignBottom
            popover.y = position.y + padding
        }

        if (popover.x < padding) {
            popover.offset = popover.x - padding
            popover.x = padding
        } else if (popover.x + popover.width > popover.parent.width - padding) {
            popover.offset = popover.x + popover.width - (popover.parent.width - padding)
            popover.x = popover.parent.width - padding - popover.width
        } else {
            popover.offset = 0
        }

        showing = true/*
        currentOverlay = popover
        opened()*/
    }

    opacity: showing ? 1 : 0
    visible: opacity > 0

    implicitWidth: units.dp(300)

    width: implicitWidth
    height: showing ? implicitHeight : 0

    elevation: 2
    radius: units.dp(2)

    Behavior on opacity {
        NumberAnimation { duration: 300 }
    }

    Behavior on height {
        NumberAnimation { duration: 300 }
    }
}
