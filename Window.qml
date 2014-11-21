/*
 * Quartz Shell - The desktop shell for Quartz OS following Material Design
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

// TODO: This is mostly just for testing. The contents will need to be replaced with a Wayland surface
View {
    id: window
    width: 500
    height: 400

    x: Math.random() * (parent.width - width)
    y: Math.random() * (parent.height - height)

    elevation: active ? 5 : 3

    property string appName: "Simple Application"
    property color headerColor: "#0097a7"
    property color toolbarColor: "#00bcd4"
    property url icon: Qt.resolvedUrl("images/play_music.png")
    property bool active: window == currentWindow
    z: windowOrder.indexOf(window)

    property string badge

    Rectangle {
        id: header
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        height: units.dp(32)
        color: headerColor

        Label {
            anchors {
                left: parent.left
                leftMargin: units.dp(10)
                verticalCenter: parent.verticalCenter
            }

            color: "white"
            text: appName
            opacity: window.maximized ? 0 : 1

            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }
        }
    }

    Item {
        id: surface

        anchors {
            left: parent.left
            right: parent.right
            top: header.bottom
            bottom: parent.bottom
        }

        Toolbar {
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            backgroundColor: toolbarColor
        }

        MouseArea {
            anchors.fill: parent
        }

        z: 1
    }


    MouseArea {
        anchors.fill: parent

        z: window.active ? 0 : 2

        drag {
            axis: Drag.XAndYAxis
            minimumX: 0
            minimumY: 0
            maximumX: window.parent.width - window.width
            maximumY: window.parent.height - window.height
            target: window
        }

        onDoubleClicked: {
            window.maximize()
        }

        onPressed: {
            window.activate()
        }
    }

    property bool maximized
    property bool minimized

    function minimize(launcher) {
        minimized = true

        var pos = launcher.mapToItem(window.parent, 0, launcher.height/2)

        oldX = x
        oldY = y

        x = 0 - width/2
        y = pos.y - height/2
    }

    function maximize() {
        window.activate()
        maximized = true

        x = 0
        y = -units.dp(32)
        width = Qt.binding(function() { return parent.width })
        height = Qt.binding(function() { return parent.height + units.dp(32) })
    }

    function activate() {
        if (minimized) {
            minimized = false

            x = oldX
            y = oldY
        }

        windowOrder.splice(windowOrder.indexOf(window), 1)
        windowOrder.push(window)
        windowOrder = windowOrder

        dashboard.showing = false
    }

    property real oldX
    property real oldY

    scale: minimized ? 0 : 1

    Behavior on scale {
        NumberAnimation { duration: 300 }
    }

    Behavior on x {
        NumberAnimation { duration: 300 }
    }

    Behavior on y {
        NumberAnimation { duration: 300 }
    }

    Behavior on width {
        NumberAnimation { duration: 300 }
    }

    Behavior on height {
        NumberAnimation { duration: 300 }
    }
}
