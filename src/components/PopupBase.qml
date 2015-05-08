/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 * Copyright (C) 2015 Michael Spencer
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

Rectangle {
    id: popover

    property bool showing
    property Item caller
    property int offset
    property var padding: Units.dp(16)
    property var side

    color: "transparent"

    function open(widget) {
        openAt(widget, 0, 0)
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
        popover.y = Qt.binding(function() {
            if (position.y + widget.height + popover.height + 2 * padding > overlayLayer.height) {
                side = Qt.AlignTop

                y = position.y - popover.height - padding

                if (y < padding) {
                    y = padding
                    side = Qt.AlignVCenter
                }
            } else {
                side = Qt.AlignBottom
                y = position.y + widget.height + padding
            }

            return y
        })

        popover.x = Qt.binding(function() {
            var x = position.x + widget.width/2 - popover.width/2

            if (x < padding) {
                popover.offset = x - padding
                x = padding
            } else if (x + popover.width > popover.parent.width - padding) {
                popover.offset = x + popover.width - (popover.parent.width - padding)
                x = popover.parent.width - padding - popover.width
            } else {
                popover.offset = 0
            }

            return x
        })

        showing = true
    }
}
