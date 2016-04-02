/****************************************************************************
 * This file is part of Hawaii.
 *
 * Copyright (C) 2014-2016 Pier Luigi Fiorini
 *
 * Author(s):
 *    Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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

MouseArea {
    property var scaler

    property real x1: 0.0
    property real y1: 0.0
    property real x2: 0.0
    property real y2: 0.0
    property real zoom1: 1.0
    property real zoom2: 1.0
    property real min: 1.0
    property real max: 10.0

    id: zoomArea
    acceptedButtons: Qt.NoButton
    propagateComposedEvents: true
    drag.target: parent
    drag.filterChildren: true
    onWheel: {
        if (!(wheel.modifiers & Qt.MetaModifier)) {
            wheel.accepted = false;
            return;
        }

        zoomArea.x1 = scaler.origin.x;
        zoomArea.y1 = scaler.origin.y;
        zoomArea.zoom1 = scaler.xScale;
        zoomArea.x2 = wheel.x;
        zoomArea.y2 = wheel.y;

        var newZoom;
        if (wheel.angleDelta.y > 0) {
            newZoom = zoomArea.zoom1 + 0.1;
            if (newZoom <= zoomArea.max)
                zoomArea.zoom2 = newZoom;
            else
                zoomArea.zoom2 = zoomArea.max;
        } else {
            newZoom = zoomArea.zoom1 - 0.1;
            if (newZoom >= zoomArea.min)
                zoomArea.zoom2 = newZoom;
            else
                zoomArea.zoom2 = zoomArea.min;
        }

        wheel.accepted = true;
    }
}
