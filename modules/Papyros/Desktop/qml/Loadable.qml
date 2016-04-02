/****************************************************************************
 * This file is part of Fluid.
 *
 * Copyright (C) 2015-2016 Pier Luigi Fiorini
 *
 * Author(s):
 *    Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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

Item {
    property Component component
    property var showAnimation
    property var hideAnimation
    property alias asynchronous: loader.asynchronous
    property alias item: loader.item

    id: root
    visible: false

    Loader {
        id: loader
        anchors.fill: parent
        asynchronous: true
        onStatusChanged: {
            if (status != Loader.Ready)
                return;
            if (item.showAnimation == undefined && root.showAnimation != undefined)
                item.showAnimation = root.showAnimation;
            if (item.hideAnimation == undefined && root.hideAnimation != undefined)
                item.hideAnimation = root.hideAnimation;
            root.visible = true;
            if (item.show != undefined)
                item.show();
        }
    }

    Connections {
        target: loader.item
        onVisibleChanged: {
            // Unload component as soon as it's hidden and hide this item as well
            if (!loader.item.visible) {
                loader.sourceComponent = undefined;
                root.visible = false;
            }
        }
    }

    function show() {
        loader.sourceComponent = root.component;
    }

    function hide() {
        if (loader.item && loader.item.hide != undefined)
            loader.item.hide();
    }
}
