/****************************************************************************
 * This file is part of Green Island.
 *
 * Copyright (C) 2014-2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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
    property Item windowItem

    property var mapAnimation: null
    property var unmapAnimation: null
    property var destroyAnimation: null

    signal mapAnimationStarted()
    signal mapAnimationStopped()

    signal unmapAnimationStarted()
    signal unmapAnimationStopped()

    signal destroyAnimationStarted()
    signal destroyAnimationStopped()

    id: root
    onMapAnimationChanged: {
        if (mapAnimation) {
            mapAnimation.started.connect(root.mapAnimationStarted);
            mapAnimation.stopped.connect(root.mapAnimationStopped);
        }
    }
    onUnmapAnimationChanged: {
        if (unmapAnimation) {
            unmapAnimation.started.connect(root.unmapAnimationStarted);
            unmapAnimation.stopped.connect(root.unmapAnimationStopped);
        }
    }
    onDestroyAnimationChanged: {
        if (destroyAnimation) {
            destroyAnimation.started.connect(root.destroyAnimationStarted);
            destroyAnimation.stopped.connect(root.destroyAnimationStopped);
        }
    }
}
