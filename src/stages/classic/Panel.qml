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
import QtQuick 2.3
import Material 0.1
import Material.Desktop 0.1

import "../../components"
import "../../indicators"
import "../../launcher"
import "../../desktop"

View {
    id: panel

    property Indicator selectedIndicator

    backgroundColor: shell.state == "exposed" ? Qt.rgba(0,0,0,0) : Qt.rgba(0.2, 0.2, 0.2, 1)
    height: Units.dp(56)

    Behavior on backgroundColor {
        ColorAnimation { duration: 300 }
    }

    anchors {
        left: parent.left
        right: parent.right
        bottom: parent.bottom
    }

    Row {
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom

        }

        IndicatorView {
            width: height
            iconSize: Units.dp(24)
            indicator: AppDrawer {
                id: appDrawer
            }
        }

        Repeater {
            model: windowManager.windows

            delegate: Ink {
                id: appLauncher
                width: parent.height
                height: width

                hoverEnabled: true

                DesktopFile {
                    id: desktopFile
                    appId: window.appId
                }

                AppIcon {
                    iconName: desktopFile.iconName
                    name: desktopFile.name
                    anchors.centerIn: parent
                    width: parent.width * 0.55
                    height: width
                }

                onEntered: {
                    windowPreview.item = item
                    windowPreview.window = window
                    
                    if (!windowPreview.showing) {
                        print("Opening")
                        windowPreview.open(appLauncher, 0, Units.dp(8))
                    }
                }

                onExited: {
                    if (windowPreview.showing)
                        windowPreview.close()
                }               

                onClicked: windowManager.moveFront(item)

                Rectangle {
                    width: parent.width
                    height: Units.dp(2)
                    anchors.bottom: parent.bottom
                    color: "white"
                    visible: windowManager.activeWindow == item
                }
            }
        }
    }

    Row {
        id: indicatorsRow

        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            rightMargin: Units.dp(16)
        }

        IndicatorView {
            indicator: DateTimeIndicator {}
        }

        Repeater {
            model: shell.indicators
            delegate: IndicatorView {
                indicator: modelData
            }
        }
    }

    WindowTooltip {
        id: windowPreview
        overlayLayer: "desktopTooltipOverlayLayer"
    }
}
