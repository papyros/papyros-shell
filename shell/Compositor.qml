/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 *
 * Copyright (C) 2016 Michael Spencer <sonrisesoftware@gmail.com>
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

import QtQuick 2.6
import GreenIsland 1.0

WaylandCompositor {
    id: compositor

    property QtObject primarySurfacesArea: null

    onCreateSurface: {
        var surface = surfaceComponent.createObject(compositor, {});
        surface.initialize(compositor, client, id, version);
    }

    GlobalPointerTracker {
        id: globalPointerTracker
        compositor: compositor
    }

    ScreenManager {
        id: screenManager

        onScreenAdded: {
            console.time("output" + __private.outputs.length);
            var view = screenComponent.createObject(
                        compositor, {
                            "compositor": compositor,
                            "nativeScreen": screen
                        });
            __private.outputs.push(view);
            windowManager.recalculateVirtualGeometry();
            console.timeEnd("output" + __private.outputs.length - 1);
        }
        onScreenRemoved: {
            var index = screenManager.indexOf(screen);
            console.time("output" + index);
            if (index < __private.outputs.length) {
                var output = __private.outputs[index];
                __private.outputs.splice(index, 1);
                output.destroy();
                windowManager.recalculateVirtualGeometry();
            }
            console.timeEnd("output" + index);
        }
        onPrimaryScreenChanged: {
            var index = screenManager.indexOf(screen);
            if (index < __private.outputs.length) {
                compositor.primarySurfacesArea = __private.outputs[index].surfacesArea;
                compositor.defaultOutput = __private.outputs[index];
            }
        }
    }

    Shortcut {
        context: Qt.ApplicationShortcut
        sequence: "Ctrl+Alt+Backspace"
        onActivated: Qt.quit()
    }

    WindowManager {
        id: windowManager
        compositor: compositor
        onWindowCreated: {
            for (var i = 0; i < __private.outputs.length; i++) {
                var output = __private.outputs[i]

                var view = windowComponent.createObject(output.surfacesArea, {"window": window})
                view.initialize(window, output)
            }
        }

        Component.onCompleted: {
            initialize()
        }
    }

    QtObject {
        id: __private

        property variant outputs: []
    }

    Component {
        id: screenComponent

        ScreenView {}
    }

    Component {
        id: surfaceComponent

        WaylandSurface {}
    }

    Component {
        id: windowComponent

        WaylandWindow {}
    }
}
