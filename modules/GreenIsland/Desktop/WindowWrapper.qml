/****************************************************************************
 * This file is part of Green Island.
 *
 * Copyright (C) 2012-2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *               2015 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * Author(s):
 *    Pier Luigi Fiorini
 *    Michael Spencer
 *
 * $BEGIN_LICENSE:LGPL2.1+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

import QtQuick 2.0
import QtCompositor 1.0
import GreenIsland 1.0

Item {
    id: window
    objectName: "clientWindow"

    visible: false

    rotation: {
        switch (_greenisland_output.transform) {
            case WaylandOutput.Transform90:
                return 90;
            case WaylandOutput.TransformFlipped90:
                return -90;
            case WaylandOutput.Transform180:
                return 180;
            case WaylandOutput.TransformFlipped180:
                return -180;
            case WaylandOutput.Transform270:
                return 270;
            case WaylandOutput.TransformFlipped270:
                return -270;
            default:
                return 0;
        }
    }

    x: child ? child.localX : 0
    y: child ? child.localY : 0
    width: clientWindow ? clientWindow.size.width : 0
    height: clientWindow ? clientWindow.size.height : 0

    property var windowManager
    property Component unresponsiveEffectComponent
    property var workspace

    property var clientWindow
    property var child
    property bool unresponsive: false
    property var animation: null

    Component.onCompleted: {
        child.parent = window;
        child.anchors.fill = Qt.binding(function() { return window });
        child.touchEventsEnabled = true;

        // Set transient children so that the parent can be desaturated
        if (clientWindow.type === ClientWindow.Transient)
            parent.transientChildren = window;
        // Set popup child to enable dim effect
        else if (clientWindow.type === ClientWindow.Popup)
            parent.popupChild = window;

        visible = true

        // z-order and focus
        if (clientWindow.type === ClientWindow.TopLevel) {
            window.z = windowManager.windows.count;
            clientWindow.activate();
        } else if (clientWindow.type === ClientWindow.Transient) {
            child.takeFocus();
        }

        if (animation) {
            animation.windowItem = window
            if (animation.mapAnimation)
                animation.mapAnimation.start()
        }
    }

    /*
     * Connections to client window, child or surface
     */

    Connections {
        target: clientWindow

        onFullScreenChanged: {
            // Save old parent and reparent to the full screen layer
            if (clientWindow.fullScreen) {
                workspaceModel.makeWindowFullscreen(window)
            } else {
                workspaceModel.makeWindowRegular(window, workspace)
            }
        }
    }

    Connections {
        target: child ? child.surface : null
        onPong: pongSurface()
    }

    Binding {
        target: child ? child.surface : null
        property: "clientRenderingEnabled"
        value: window.visible
    }

    function kill() {
        window.child.surface.client.kill()
    }

    function close(destroy) {
        if (animation) {
            // Break the binding so the window stays the same size as it fades out
            x = x
            y = y
            width = width
            height = height

            if (destroy) {
                if (animation.destroyAnimation) {
                    animation.destroyAnimation.start()
                    return
                } else if (animation.unmapAnimation) {
                    animation.unmapAnimation.start()
                    return
                }
            } else {
                if (animation.unmapAnimation) {
                    animation.unmapAnimation.start()
                    return
                } else if (animation.destroyAnimation) {
                    animation.destroyAnimation.start()
                    return
                }
            }
        }
        window.child.paintEnabled = false;
        window.destroy()
    }

    Connections {
        target: animation
        onUnmapAnimationStopped: {
            // Destroy window representation
            window.child.paintEnabled = false;
            window.destroy();
        }
        onDestroyAnimationStopped: {
            // Destroy window representation
            window.child.paintEnabled = false;
            window.destroy();
        }
    }

    ////////// Unresponsive surface handling //////////

    MouseArea {
        anchors.fill: parent
        enabled: window.unresponsive
        cursorShape: Qt.BusyCursor
        z: 1
        visible: enabled
    }

    Loader {
        id: unresponsiveEffectLoader
        anchors.fill: parent

        active: opacity > 0
        sourceComponent: unresponsiveEffectComponent

        opacity: unresponsive ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                easing.type: Easing.Linear
                duration: 250
            }
        }
        z: 1
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: window.pingSurface()
    }

    Timer {
        id: pingPongTimer
        interval: 200
        onTriggered: unresponsive = true
    }

    function pingSurface() {
        print("PING!")
        // Ping logic applies only to windows actually visible
        if (!visible)
            return;

        // Ping the surface to see whether it's responsive, if a pong
        // doesn't arrive before the timeout is trigger we know the
        // surface is unresponsive and raise the flag
        child.surface.ping();
        pingPongTimer.running = true;
    }

    function pongSurface() {
        // Surface replied with a pong this means it's responsive
        pingPongTimer.running = false;
        unresponsive = false;
    }
}
