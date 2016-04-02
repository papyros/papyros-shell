/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 *
 * Copyright (C) 2016 Michael Spencer <sonrisesoftware@gmail.com>
 *               2012-2016 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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
import GreenIsland 1.0 as GreenIsland
import Papyros.Desktop 0.1
import "desktop"

GreenIsland.WaylandCompositor {
    id: papyrosCompositor

    readonly property alias outputs: __private.outputs
    readonly property alias primaryScreen: screenManager.primaryScreen

    property int idleInhibit: 0

    readonly property alias windowsModel: windowsModel
    readonly property alias applicationManager: applicationManager
    extensions: [
        GreenIsland.ApplicationManager {
            id: applicationManager

            Component.onCompleted: {
                initialize();
            }
        },
        GreenIsland.Screencaster {
            id: screencaster

            Component.onCompleted: {
                initialize();
            }
        },
        GreenIsland.Screenshooter {
            id: screenshooter
            onCaptureRequested: {
                // TODO: We might want to do something depending on the capture type - plfiorini
                switch (screenshot.captureType) {
                case GreenIsland.Screenshot.CaptureActiveWindow:
                case GreenIsland.Screenshot.CaptureWindow:
                case GreenIsland.Screenshot.CaptureArea:
                    break;
                default:
                    break;
                }

                // Setup client buffer
                screenshot.setup();
            }

            Component.onCompleted: {
                initialize();
            }
        }
    ]
    onCreateSurface: {
        var surface = surfaceComponent.createObject(papyrosCompositor, {});
        surface.initialize(papyrosCompositor, client, id, version);
    }

    /*
     * Components
     */

    // Private properties
    QtObject {
        id: __private

        property variant outputs: []
    }

    // Pointer tracking with global coordinates
    GreenIsland.GlobalPointerTracker {
        id: globalPointerTracker
        compositor: papyrosCompositor
    }

    // Key bindings
    KeyBindings {}

    // Screen manager
    GreenIsland.ScreenManager {
        id: screenManager
        onScreenAdded: {
            var view = outputComponent.createObject(
                        papyrosCompositor, {
                            "compositor": papyrosCompositor,
                            "nativeScreen": screen
                        });
            __private.outputs.push(view);
            windowManager.recalculateVirtualGeometry
        }
        onScreenRemoved: {
            var index = screenManager.indexOf(screen);
            if (index < __private.outputs.length) {
                var output = __private.outputs[index];
                __private.outputs.splice(index, 1);
                output.destroy();
                windowManager.recalculateVirtualGeometry();
            }
        }
        onPrimaryScreenChanged: {
            var index = screenManager.indexOf(screen);
            if (index < __private.outputs.length) {
                console.debug("Setting screen", index, "as primary");
                papyrosCompositor.defaultOutput = __private.outputs[index];
            }
        }
    }

    // Idle manager
    Timer {
        id: idleTimer
        interval: Number(60) * 1000
        running: true
        repeat: true
        onTriggered: {
            var i, output, idleHint = false;
            for (i = 0; i < __private.outputs.length; i++) {
                output = __private.outputs[i];
                if (idleInhibit + output.idleInhibit == 0) {
                    output.idle();
                    idleHint = true;
                }
            }

            // SessionInterface.idle = idleHint;
        }
    }

    // Windows
    ListModel {
        id: windowsModel
    }

    // Window manager
    GreenIsland.WindowManager {
        id: windowManager
        compositor: papyrosCompositor
        onWindowCreated: {
            var i, output, view;
            for (i = 0; i < __private.outputs.length; i++) {
                output = __private.outputs[i];
                view = windowComponent.createObject(output.surfacesArea, {"window": window});
                view.initialize(window, output);
            }

            window.typeChange__private.connect(function() {
                if (window.type == GreenIslan__private.ClientWindow.TopLevel)
                    windowsModel.append({"window": window});
            });
        }

        Component.onCompleted: {
            initialize();
        }
    }

    // Surface component
    Component {
        id: surfaceComponent

        GreenIsland.WaylandSurface {}
    }

    // Window component
    Component {
        id: windowComponent

        GreenIsland.WaylandWindow {}
    }

    // Output component
    Component {
        id: outputComponent

        Output {}
    }

    /*
     * Methods
     */

    function wake() {
        var i;
        for (i = 0; i < __private.outputs.length; i++) {
            idleTimer.restart();
            __private.outputs[i].wake();
        }

        // SessionInterface.idle = false;
    }

    function idle() {
        var i;
        for (i = 0; i < __private.outputs.length; i++)
            __private.outputs[i].idle();

        // SessionInterface.idle = true;
    }
}
