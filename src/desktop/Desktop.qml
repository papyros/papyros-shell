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
    }

    ListView {
        id: listView
        anchors {
            fill: parent
            leftMargin: expanded ? horizontalOffset : 0
            rightMargin: expanded ? horizontalOffset : 0
            topMargin: expanded ? verticalOffset : 0
            bottomMargin: expanded ? verticalOffset : 0

            Behavior on leftMargin {
                NumberAnimation { duration: 300 }
            }

            Behavior on rightMargin {
                NumberAnimation { duration: 300 }
            }

            Behavior on topMargin {
                NumberAnimation { duration: 300 }
            }

            Behavior on bottomMargin {
                NumberAnimation { duration: 300 }
            }
        }

        displayMarginBeginning: horizontalOffset
        displayMarginEnd: horizontalOffset

        snapMode: ListView.SnapOneItem

        orientation: Qt.Horizontal
        interactive: desktop.expanded
        highlightFollowsCurrentItem: true
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 500
        currentIndex: 0

        spacing: expanded ? horizontalOffset * 0.70 : 0

        Behavior on spacing {
            NumberAnimation { duration: 300 }
        }

        model: 1
        delegate: View {
            elevation: 5
            width: listView.width
            height: listView.height

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
    }

    function updateTooltip(indicator, containsMouse) {
        if (containsMouse) {
            if (indicator.indicator.tooltip && selectedIndicator == null) {
                tooltip.text =indicator.indicator.tooltip
                tooltip.open(indicator, 0, Units.dp(16))
            }
        } else if (tooltip.showing) {
            tooltip.close()
        }
    }

    Tooltip {
        id: tooltip
    }

    Connections {
        target: shell
        onSelectedIndicatorChanged: tooltip.close()
    }
}
