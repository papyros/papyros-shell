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
    z: 3

    property var popupChild: null
    property var transientChildren: null
    
    property bool dimForDialogs: true

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
        onActiveChanged: if (clientWindow.active) window.child.takeFocus()
    }
}
