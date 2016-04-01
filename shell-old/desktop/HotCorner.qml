/****************************************************************************
 * This file is part of Green Island.
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
import Material 0.1

Item {
    id: hotCorner

    property int type: Item.TopLeft

    signal triggered()

    // FIXME: Size depends on DPIs
    width: type == Item.Top || type == Item.Bottom ||
            type == Item.Left || type == Item.Right ? Units.dp(64) : Units.dp(80)
    height: width

    QtObject {
        id: __priv

        property int threshold: 5
        property bool entered: false
        property double lastTrigger

        Component.onCompleted: lastTrigger = new Date().getTime()
    }

    Rectangle {
        id: ink

        anchors.centerIn: parent

        border.color: "#ffffff"
        border.width: 2

        height: width
        radius: width/2
        color: Qt.rgba(0,0,0,0.4)
        opacity: 0

        ParallelAnimation {
            id: startAnimation
            NumberAnimation {
                target: ink; property: "opacity"; to: 0.5; duration: 200
            }

            NumberAnimation {
                target: ink; property: "width"; from: 0; to: hotCorner.width; duration: 200
            }
        }

        ParallelAnimation {
            id: finishAnimation
            SequentialAnimation {
                NumberAnimation {
                    target: ink; property: "opacity"; to: 1; duration: 300
                }

                NumberAnimation {
                    target: ink; property: "opacity"; to: 0; duration: 100
                }
            }

            NumberAnimation {
                target: ink; property: "width"; to: hotCorner.width * 3; duration: 400
            }
        }

        ParallelAnimation {
            id: stopAnimation
            NumberAnimation {
                target: ink; property: "opacity"; to: 0; duration: 200
            }

            NumberAnimation {
                target: ink; property: "width"; to: 0; duration: 200
            }
        }

        function finish() {
            if (!finishAnimation.running) {
                stopAnimation.stop()
                startAnimation.stop()

                finishAnimation.start()
            }
        }

        function cancel() {
            if (!finishAnimation.running) {
                startAnimation.stop()
                stopAnimation.start()
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        hoverEnabled: true
        onEntered: startAnimation.start()
        onExited: ink.cancel()
    }

    MouseArea {
        id: surroundingArea

        anchors.centerIn: parent

        width: Units.dp(5)
        height: Units.dp(5)
        acceptedButtons: Qt.NoButton
        hoverEnabled: true
        onExited: {
            __priv.entered = false;
        }

        MouseArea {
            id: cornerArea
            anchors.centerIn: parent
            width: hotCorner.type == Item.Top || hotCorner.type == Item.Bottom ? hotCorner.width : 5
            height: hotCorner.type == Item.Left || hotCorner.type == Item.Right ? hotCorner.height : 5
            acceptedButtons: Qt.NoButton
            hoverEnabled: true
            onEntered: {
                if (!__priv.entered) {
                    print("Triggered")
                    __priv.entered = true;
                    hotCorner.triggered();
                    ink.finish()
                }
            }
        }
    }
}
