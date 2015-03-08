/****************************************************************************
 * This file is part of Green Island.
 *
 * Copyright (C) 2012-2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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
import GreenIsland 1.0

WindowWrapper {
    property var popupChild: null
    property var transientChildren: null

    id: window
    objectName: "clientWindow"
    animation: TransientWindowAnimation {
        windowItem: window
    }
    z: 3

    // Decrease contrast for transient parents
    ContrastEffect {
        id: contrast
        x: clientWindow ? clientWindow.internalGeometry.x : 0
        y: clientWindow ? clientWindow.internalGeometry.y : 0
        width: clientWindow ? clientWindow.internalGeometry.width : 0
        height: clientWindow ? clientWindow.internalGeometry.height : 0
        source: window
        blend: transientChildren ? 0.742 : 1.0
        color: "black"
        z: visible ? 2 : 0
        visible: transientChildren != null

        Behavior on blend {
            NumberAnimation {
                easing.type: transientChildren ? Easing.InQuad : Easing.OutQuad
                duration: 250
            }
        }
    }
}
