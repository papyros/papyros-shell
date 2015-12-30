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
import Papyros.Components 0.1
import Papyros.Desktop 0.1
import Papyros.Indicators 0.1

import "../../launcher"
import "../../desktop"

View {
    id: panel

    property color darkColor: Qt.rgba(0.2, 0.2, 0.2, 1)
    property bool maximized: windowManager.currentWorkspace.hasMaximizedWindow ||
            !ShellSettings.appShelf.transparentShelf

    backgroundColor: Qt.rgba(0.2, 0.2, 0.2, maximized ? 1 : 0)
    height: Units.dp(56)
    clipContent: false

    anchors {
        left: parent.left
        right: parent.right
        bottom: parent.bottom
    }

    Connections {
        target: shell

        onSuperPressed: appDrawerButton.toggle()
    }

    RowLayout {
        anchors {
            left: parent.left
            right: indicatorsRow.left
            top: parent.top
            bottom: parent.bottom
        }

        spacing: 0

        Item {
            height: parent.height
            Layout.preferredWidth: 2 * height

            View {
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                    margins: Units.dp(8)
                }

                width: height

                elevation: panel.maximized || shell.state == "exposed" ? 0 : 2
                radius: Units.dp(2)
                backgroundColor: panel.darkColor
            }

            View {
                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                    margins: Units.dp(8)
                }

                width: height

                elevation: panel.maximized || shell.state == "exposed" ? 0 : 2
                radius: Units.dp(2)
                backgroundColor: panel.darkColor
            }

            Row {
                id: leftRow
                anchors {
                    fill: parent
                    margins: panel.maximized ? 0 : Units.dp(8)
                }

                spacing: anchors.margins * 2

                IndicatorView {
                    id: appDrawerButton
                    width: height
                    iconSize: Units.dp(24)
                    indicator: AppDrawer {
                        id: appDrawer
                    }
                }

                PanelItem {
                    selected: shell.state == "exposed"
                    tooltip: windowManager.workspaces.count > 1
                            ? qsTr("%1 workspaces").arg(windowManager.workspaces.count)
                            : qsTr("1 workspace")

                    onClicked: shell.toggleState("exposed")

                    Icon {
                        anchors.centerIn: parent
                        source: Qt.resolvedUrl("../../images/workspaces-expose.svg")
                        color: Theme.dark.iconColor
                    }
                }
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            orientation: Qt.Horizontal

            interactive: contentWidth > width

            model: AppLauncherModel
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

    View {
        id: indicatorsRow

        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            margins: Units.dp(8)
        }

        elevation: panel.maximized || shell.state == "exposed" ? 0 : 2
        radius: Units.dp(2)
        backgroundColor: panel.darkColor

        width: row.implicitWidth + Units.dp(16)
        clipContent: false

        Row {
            id: row

            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
                leftMargin: Units.dp(8)
                rightMargin: Units.dp(8)
                margins: panel.maximized ? Units.dp(-8) : 0
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
