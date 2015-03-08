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

WindowAnimation {
    id: animation

    Scale {
        id: scaleTransform
        origin.x: animation.windowItem.width / 2
        origin.y: animation.windowItem.height / 2
        xScale: 0.9
        yScale: 0.9
    }

    Rotation {
        id: rotationTransform
        origin.x: animation.windowItem.width / 2
        origin.y: animation.windowItem.height / 2
        axis.x: 0
        axis.y: 0
        axis.z: 10
    }

    mapAnimation: SequentialAnimation {
        ScriptAction { script: animation.windowItem.transform = [scaleTransform, rotationTransform] }

        ParallelAnimation {
            NumberAnimation {
                target: animation.windowItem
                property: "opacity"
                easing.type: Easing.OutQuad
                from: 0.0
                to: 1.0
                duration: 150
            }
            NumberAnimation {
                target: scaleTransform
                property: "xScale"
                easing.type: Easing.OutQuad
                to: 1.0
                duration: 150
            }
            NumberAnimation {
                target: scaleTransform
                property: "yScale"
                easing.type: Easing.OutQuad
                to: 1.0
                duration: 150
            }
        }

        ScriptAction { script: animation.windowItem.transform = null }
    }

    unmapAnimation: NumberAnimation {
        target: animation.windowItem
        property: "opacity"
        easing.type: Easing.Linear
        to: 0.0
        duration: 150
    }

    destroyAnimation: ParallelAnimation {
        NumberAnimation {
            target: animation.windowItem
            property: "scale"
            easing.type: Easing.OutQuad
            to: 0.8
            duration: 150
        }
        NumberAnimation {
            target: animation.windowItem
            property: "opacity"
            easing.type: Easing.OutQuad
            to: 0.0
            duration: 150
        }
    }
}
