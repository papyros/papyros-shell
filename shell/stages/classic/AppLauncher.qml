/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 * Copyright (C) 2015 Michael Spencer
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
import Material 0.2
import Material.ListItems 0.1 as ListItem
import Material.Extras 0.1
import Papyros.Components 0.1
import Papyros.Desktop 0.1

import "../../launcher"
import "../../desktop"

PanelItem {
    id: appLauncher

    tintColor: containsMouse ? Qt.rgba(0,0,0,0.2) : Qt.rgba(0,0,0,0)
    highlightColor: starting ? Palette.colors.orange["500"] : "white"
    highlightOpacity: active || starting ? 1 : running ? 0.4 : 0
    selected: active

    SequentialAnimation on y {
        loops: Animation.Infinite
        running: starting
        alwaysRunToEnd: true

        NumberAnimation {
            from: 0; to: -appLauncher.height/2
            easing.type: Easing.OutExpo; duration: 300
        }

        NumberAnimation {
            from: -appLauncher.height/2; to: 0
            easing.type: Easing.OutBounce; duration: 1000
        }

        PauseAnimation { duration: 500 }
    }

    property var listView: ListView.view

    property var windows: ListUtils.filter(windowManager.windows, function(modelData) {
        return modelData.window.appId == appId
    })

    property bool active: focused && getMainWorkspace() == windowManager.currentWorkspace

    function getMainWorkspace() {
        var workspace

        for (var i = 0; i < windows.length; i++) {
            if (workspace != windowManager.currentWorkspace)
                workspace = windows[i].item.workspace
        }

        return workspace
    }

    onClicked: {
        if (!running) {
            appLauncher.listView.model.get(index).launch()
        } else if (active) {
            // TODO: Spread windows
        } else {
            windowManager.focusApplication(appId)
        }
    }

    onRightClicked: {
        if (popupMenu) {
            if (!popupMenu.showing) {
                popupMenu.open(appLauncher, 0, Units.dp(16))
            } else {
                popupMenu.close()
            }
        }
    }

    onContainsMouseChanged: {
        if (containsMouse) {
            previewTimer.delayShow(appLauncher, model, windows)
        } else {
            if (windowPreview.showing)
                windowPreview.close()

            delayCloseTimer.restart()
            previewTimer.stop()
        }
    }

    AppIcon {
        iconName: desktopFile.iconName
        hasIcon: desktopFile.hasIcon
        name: desktopFile && desktopFile.name !== "" ? desktopFile.name : appId
        anchors.centerIn: parent
        width: parent.width * 0.55
        height: width
    }

    Popover {
        id: popupMenu

        overlayLayer: "desktopOverlayLayer"

        height: column.height
        width: Units.dp(250)

        View {
            anchors.fill: parent
            elevation: 2
            radius: Units.dp(2)
        }

        Column {
            id: column
            width: parent.width

            Repeater {
                model: windows
                delegate: ListItem.Standard {
                    text: modelData.window.title
                    showDivider: index == windows.length - 1
                }
            }

            ListItem.Standard {
                text: "New Window"
                enabled: false
                showDivider: !closeItem.visible
            }

            ListItem.Standard {
                id: closeItem
                text: "Close application"
                showDivider: true
                visible: running
                onClicked: {
                    popupMenu.close()
                    appLauncher.listView.model.get(index).quit()
                }
            }

            ListItem.Standard {
                text: "Pin to dock"

                onClicked: checkbox.checked = !checkbox.checked

                Switch {
                    id: checkbox

                    checked: pinned

                    onCheckedChanged: {
                        if (!appLauncher.listView)
                            return

                        if (pinned) {
                            appLauncher.listView.model.unpin(model.appId);
                        } else {
                            appLauncher.listView.model.pin(model.appId);
                        }

                        checked = Qt.binding(function() { return pinned })
                        popupMenu.close()
                    }

                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        rightMargin: (parent.height - height)/2
                    }
                }
            }
        }
    }
}
