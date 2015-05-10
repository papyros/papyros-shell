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

            delegate: View {
                id: appLauncher
                
                width: parent.height
                height: width

                tintColor: ink.containsMouse ? Qt.rgba(0,0,0,0.2) : Qt.rgba(0,0,0,0)

                Ink {
                    id: ink
                    anchors.fill: parent

                    hoverEnabled: true

                    onContainsMouseChanged: {
                        if (containsMouse) {
                            if (selectedIndicator == null)
                                previewTimer.delayShow(appLauncher, window, item)
                        } else if (windowPreview.showing) {
                            windowPreview.close()
                            delayCloseTimer.restart()
                            previewTimer.stop()
                        }
                    }               

                    onClicked: windowManager.moveFront(item)
                }

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

    Timer {
        id: delayCloseTimer
        interval: 10
    }

    Timer {
        id: previewTimer

        property var window
        property var item
        property var caller

        interval: 1000

        function delayShow(caller, window, item) {
            if (windowPreview.showing || delayCloseTimer.running) {
                windowPreview.window = window
                windowPreview.item = item
                windowPreview.open(caller, 0, Units.dp(16))
            } else {
                previewTimer.window = window
                previewTimer.item = item
                previewTimer.caller = caller
                restart()
            }
        }

        onTriggered: {
            windowPreview.window = previewTimer.window
            windowPreview.item = previewTimer.item
            windowPreview.open(previewTimer.caller, 0, Units.dp(16))
        }
    }

    WindowTooltip {
        id: windowPreview
        overlayLayer: "desktopTooltipOverlayLayer"
    }

    Connections {
        target: shell
        onSelectedIndicatorChanged: {
            previewTimer.stop()
            delayCloseTimer.stop()
            windowPreview.close()
        }
    }
}
