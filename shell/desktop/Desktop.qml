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
import "../components"

/*
 * The desktop consists of multiple workspaces, one of which is shown at a time. The desktop
 * can also go into exposed-mode,
 */
Item {
    id: desktop

    objectName: "desktop" // Used by the C++ wrapper to hook up the signals

    anchors.fill: parent

    property bool expanded: shell.state == "exposed"

    property real verticalOffset: height * 0.1
    property real horizontalOffset: width * 0.1

    property alias windowManager: windowManager
    property alias windowSwitcher: windowSwitcher
    property alias overlayLayer: desktopOverlayLayer

    function switchNext() {
        windowManager.moveFront(windowManager.orderedWindows.get(1).item)
    }

    function switchPrevious() {
        var index = windowManager.orderedWindows.count - 1

        windowManager.moveFront(windowManager.orderedWindows.get(index).item)
    }

    WindowManager {
        id: windowManager
        anchors.fill: parent

        onSelectWorkspace: {
            print("Switching to index: ", workspace.index, listView.currentIndex)

            if (workspace == listView.currentIndex) {
                print("Switching to default!")
                shell.state = "default"
            } else {
                listView.currentIndex = workspace.index
            }
        }

        topLevelWindowComponent: TopLevelWindow {
            id: window

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

    ListView {
        id: listView
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: expanded ? Units.dp(32) : 0
            
            Behavior on topMargin {
                NumberAnimation { duration: 300 }
            }
        }

        height: expanded ? Units.dp(100) : parent.height
        width: {
            if (expanded) {
                var targetWidth = Units.dp(100) * windowManager.width/windowManager.height
                return count * targetWidth + (count - 1) * Units.dp(32)
            } else {
                return parent.width
            }
        }

        Behavior on width {
            NumberAnimation { duration: 300 }
        }

        Behavior on height {
            NumberAnimation { duration: 300 }
        }

        snapMode: ListView.SnapOneItem

        orientation: Qt.Horizontal
        interactive: desktop.expanded
        highlightFollowsCurrentItem: true
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 500
        currentIndex: 0

        spacing: expanded ? Units.dp(32) : 0

        Behavior on spacing {
            NumberAnimation { duration: 300 }
        }

        model: 2
        delegate: View {
            elevation: 3
            width: height * windowManager.width/windowManager.height
            height: listView.height
            clipContent: false

            CrossFadeImage {
                id: wallpaper

                anchors.fill: parent

                fadeDuration: 500
                fillMode: Image.Stretch

                source: {
                    var filename = wallpaperSetting.pictureUri

                    if (filename.indexOf("xml") != -1) {
                        // We don't support GNOME's time-based wallpapers. Default to our default wallpaper
                        return Qt.resolvedUrl("../images/papyros_wallpaper.png")
                    } else {
                        return filename
                    }
                }
            }

            Workspace {
                id: workspace
                isCurrentWorkspace: ListView.currentItem == workspace

                scale: parent.width/width
                anchors.centerIn: parent
            }

            Label {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.bottom
                    topMargin: Units.dp(16)
                }

                text: listView.count > 1 ? "Desktop " + (index + 1) : "Desktop"
                color: Theme.dark.textColor
                style: "subheading"

                opacity: expanded ? 1 : 0

                Behavior on opacity {
                    NumberAnimation { duration: 300 }
                }
            }
        }
    }

    HotCorners {
        anchors {
            fill: parent
        }

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
            if (currentOverlay)
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
