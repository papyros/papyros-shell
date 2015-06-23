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
import GreenIsland 1.0

WindowWrapper {
    id: window
    objectName: "clientWindow"

    property var popupChild: null
    property var transientChildren: null

    property bool animationsEnabled: visible

    property alias savedProperties: saved

    property bool dimForDialogs: true

    signal minimize()

    // Decrease contrast for transient parents
    ContrastEffect {
        id: contrast
        x: clientWindow ? clientWindow.internalGeometry.x : 0
        y: clientWindow ? clientWindow.internalGeometry.y : 0
        width: clientWindow ? clientWindow.internalGeometry.width : 0
        height: clientWindow ? clientWindow.internalGeometry.height : 0
        source: window
        blend: 0.742
        color: "black"
        z: 2
        opacity: dimForDialogs && transientChildren ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                easing.type: transientChildren ? Easing.InQuad : Easing.OutQuad
                duration: 500
            }
        }
    }

    // Connect to the client window
    Connections {
        target: clientWindow
        onMotionStarted: animationsEnabled = false
        onMotionFinished: animationsEnabled = true
        onResizeStarted: animationsEnabled = false
        onResizeFinished: animationsEnabled = true
        onActiveChanged: if (clientWindow.active) windowManager.moveFront(window)
        onMaximizedChanged: {
            if (clientWindow.maximized)
                window.parent.maximizedCount++
            else
                window.parent.maximizedCount--
        }
        onMinimizedChanged: {
            print("MINIMIZE!")
            if (clientWindow.minimized) {
                // Save old position and scale
                saved.x = window.x;
                saved.y = window.y;

                minimize()
            } else {
                // Restore old properties
                window.x = saved.x;
                window.y = saved.y;
                window.scale = 1
                window.opacity = 1.0;
            }
        }
        onWindowMenuRequested: {
            // TODO: Handle window menus
        }
    }

    /*
     * Position and scale
     */

    QtObject {
        id: saved

        property real x
        property real y
        property real width
        property real height
    }

    /*
     * Animations
     */

    // NOTE: Never animate z otherwise window stacking won't work
    // because the z property will be changed progressively by
    // the animation

    Behavior on x {
        enabled: animationsEnabled
        SmoothedAnimation {
            easing.type: Easing.OutQuad
            duration: 300
        }
    }

    Behavior on y {
        enabled: animationsEnabled
        SmoothedAnimation {
            easing.type: Easing.OutQuad
            duration: 300
        }
    }

    Behavior on width {
        enabled: animationsEnabled
        SmoothedAnimation {
            easing.type: Easing.OutQuad
            duration: 300
        }
    }

    Behavior on height {
        enabled: animationsEnabled
        SmoothedAnimation {
            easing.type: Easing.OutQuad
            duration: 300
        }
    }

    Behavior on scale {
        enabled: visible
        NumberAnimation {
            easing.type: Easing.OutQuad
            duration: 300
        }
    }

    Behavior on opacity {
        enabled: visible
        NumberAnimation {
            easing.type: Easing.Linear
            duration: 300
        }
    }
}
