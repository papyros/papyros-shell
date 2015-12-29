/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 * Copyright (C) 2015 Michael Spencer <sonrisesoftware@gmail.com>
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
import QtQuick 2.4
import QtQuick.Layouts 1.0
import Material 0.1
import Material.Extras 0.1
import GreenIsland 1.0
import GreenIsland.Desktop 1.0
import Papyros.Desktop 0.1

/*
 * The desktop consists of multiple workspaces, one of which is shown at a time. The desktop
 * can also go into exposed-mode,
 */
Item {
    id: desktop

    objectName: "desktop" // Used by the C++ wrapper to hook up the signals

    anchors.fill: parent

    property bool expanded: shell.state == "exposed"

    property alias windowManager: windowManager
    property alias windowSwitcher: windowSwitcher
    property alias overlayLayer: desktopOverlayLayer

    function switchNext() {
        var appId = AppSwitcherModel.get(1).appId
        windowManager.focusApplication(appId)
    }

    function switchPrev() {
        var appId = AppSwitcherModel.get(AppSwitcherModel.count - 1).appId
        windowManager.focusApplication(appId)
    }

    function switchNextWindow() {
        var appId = AppSwitcherModel.get(0).appId
        var windows = ListUtils.filter(windowManager.orderedWindows, function(modelData) {
            return modelData.window.appId == appId
        })
        windowManager.moveFront(windows[1].item)
    }

    function switchPrevWindow() {
        var appId = AppSwitcherModel.get(0).appId
        var windows = ListUtils.filter(windowManager.orderedWindows, function(modelData) {
            return modelData.window.appId == appId
        })
        var index = windows.count - 1
        windowManager.moveFront(windows[index].item)
    }

    WindowManager {
        id: windowManager
        anchors.fill: parent

        onSelectWorkspace: {
            workspacesView.selectWorkspace(workspace.index)
        }

        topLevelWindowComponent: TopLevelWindow {
            id: window

            View {
                id: dropShadow
                anchors.fill: parent
                elevation: window.clientWindow.active ? 5 : 2
                // A hack to see if a window draws its own shadow via CSDs
                visible: window.clientWindow.internalGeometry.x == 0
                backgroundColor: "transparent"
                radius: Units.dp(2)
            }

            animation: WindowAnimation {
                mapAnimation: NumberAnimation {
                    target: window
                    property: "opacity"
                    from: 0; to: 1
                    duration: 250
                }

                unmapAnimation: ParallelAnimation {
                    NumberAnimation {
                        target: window
                        property: "opacity"
                        from: 1; to: 0
                        duration: 250
                    }
                    NumberAnimation {
                        target: window
                        property: "scale"
                        from: 1; to: 0.5
                        duration: 250
                    }
                }
            }
        }
    }

    WorkspacesView {
        id: workspacesView
        anchors.fill: parent
        exposed: expanded
    }

    HotCorners {
        anchors.fill: parent

        onTopLeftTriggered: {
            if (desktop.expanded)
                shell.state = "default"
            else
                shell.state = "exposed"
        }
    }

    WindowSwitcher {
        id: windowSwitcher
    }

    OverlayLayer {
        id: tooltipOverlayLayer
        objectName: "desktopTooltipOverlayLayer"
        z: 100
        enabled: desktopOverlayLayer.currentOverlay == null
    }

    OverlayLayer {
        id: desktopOverlayLayer
        z: 99
        objectName: "desktopOverlayLayer"

        onCurrentOverlayChanged: {
            if (currentOverlay && shell.state !== "default" && shell.state !== "locked")
                shell.state = "default"
        }
    }

    Connections {
        target: shell

        onStateChanged: {
            if (shell.state != "default" && desktopOverlayLayer.currentOverlay)
                desktopOverlayLayer.currentOverlay.close()
        }
    }

    function updateTooltip(item, containsMouse) {
        if (containsMouse) {
            if (item.tooltip) {
                tooltip.text = Qt.binding(function() { return item.tooltip })
                tooltip.open(item, 0, Units.dp(16))
            }
        } else if (tooltip.showing) {
            tooltip.close()
        }
    }

    Tooltip {
        id: tooltip
        overlayLayer: "desktopTooltipOverlayLayer"
    }
}
