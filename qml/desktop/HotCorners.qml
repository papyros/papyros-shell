/****************************************************************************
 * This file is part of Hawaii Shell.
 *
 * Copyright (C) 2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * Author(s):
 *    Pier Luigi Fiorini
 *
 * $BEGIN_LICENSE:GPL2+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

import QtQuick 2.0

Item {
    id: root

    clip: true

    signal topTriggered()
    signal bottomTriggered()
    signal leftTriggered()
    signal rightTriggered()

    signal topLeftTriggered()
    signal topRightTriggered()

    signal bottomLeftTriggered()
    signal bottomRightTriggered()

    // Top side
    HotCorner {
        id: topSide
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.top
        }
        type: Item.Top
        onTriggered: root.topTriggered()
    }

    // Bottom side
    HotCorner {
        id: bottomSide
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.bottom
        }
        type: Item.Bottom
        onTriggered: root.bottomTriggered()
    }

    // Left side
    HotCorner {
        id: leftSide
        anchors {
            horizontalCenter: parent.left
            verticalCenter: parent.verticalCenter
        }
        type: Item.Left
        onTriggered: root.leftTriggered()
    }

    // Bottom side
    HotCorner {
        id: rightSide
        anchors {
            horizontalCenter: parent.right
            verticalCenter: parent.verticalCenter
        }
        type: Item.Right
        onTriggered: root.rightTriggered()
    }

    // Top-left corner
    HotCorner {
        id: topLeftCorner
        anchors {
            horizontalCenter: parent.left
            verticalCenter: parent.top
        }
        type: Item.TopLeft
        onTriggered: root.topLeftTriggered()
    }

    // Top-right corner
    HotCorner {
        id: topRightCorner
        anchors {
            horizontalCenter: parent.right
            verticalCenter: parent.top
        }
        type: Item.TopRight
        onTriggered: root.topRightTriggered()
    }

    // Bottom-left corner
    HotCorner {
        id: bottomLeftCorner
        anchors {
            horizontalCenter: parent.left
            verticalCenter: parent.bottom
        }
        type: Item.BottomLeft
        onTriggered: root.bottomLeftTriggered()
    }

    // Bottom-right corner
    HotCorner {
        id: bottomRightCorner
        anchors {
            horizontalCenter: parent.right
            verticalCenter: parent.bottom
        }
        type: Item.BottomRight
        onTriggered: root.bottomRightTriggered()
    }
}
