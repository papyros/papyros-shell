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
import QtQuick.Layouts 1.0
import Material 0.1
import Papyros.Desktop 0.1

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

    RowLayout {
        anchors {
            left: parent.left
            right: indicatorsRow.left
            top: parent.top
            bottom: parent.bottom
        }

        spacing: 0

        IndicatorView {
            Layout.preferredWidth: height
            iconSize: Units.dp(24)
            indicator: AppDrawer {
                id: appDrawer
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            orientation: Qt.Horizontal

            interactive: contentWidth > width

            model: LauncherModel {}
            delegate: AppLauncher {
                width: parent.height
                height: width
            }

            remove: Transition {
                ParallelAnimation {
                    NumberAnimation { property: "opacity"; to: 0; duration: 250 }
                    NumberAnimation { properties: "y"; to: height; duration: 250 }
                }
            }

            removeDisplaced: Transition {
                SequentialAnimation {
                    PauseAnimation { duration: 250 }
                    NumberAnimation { properties: "x,y"; duration: 250 }
                }
            }

            move: Transition {
                SequentialAnimation {
                    PauseAnimation { duration: 250 }
                    NumberAnimation { properties: "x,y"; duration: 250 }
                }
            }

            moveDisplaced: Transition {
                SequentialAnimation {
                    PauseAnimation { duration: 250 }
                    NumberAnimation { properties: "x,y"; duration: 250 }
                }
            }

            add: Transition {
                ParallelAnimation {
                    NumberAnimation { property: "opacity"; to: 1; from: 0; duration: 250 }
                    NumberAnimation { properties: "y"; to: 0; from: height; duration: 250 }
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

        property var windows
        property var app
        property var caller

        interval: 1000

        function delayShow(caller, app, windows) {
            if (windowPreview.showing || delayCloseTimer.running) {
                windowPreview.windows = windows
                windowPreview.app = app
                windowPreview.open(caller, 0, Units.dp(16))
            } else {
                previewTimer.windows = windows
                previewTimer.app = app
                previewTimer.caller = caller
                restart()
            }
        }

        onTriggered: {
            windowPreview.windows = windows
            windowPreview.app = app
            windowPreview.open(previewTimer.caller, 0, Units.dp(16))
        }
    }

    WindowTooltip {
        id: windowPreview
        overlayLayer: "desktopTooltipOverlayLayer"
    }
}
