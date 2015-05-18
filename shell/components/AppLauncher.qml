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
import Material 0.1
import Material.ListItems 0.1 as ListItem
import Material.Extras 0.1
import Papyros.Desktop 0.1

import "../launcher"
import "../desktop"

View {
    id: appLauncher

    property var listView: ListView.view
    
    tintColor: ink.containsMouse ? Qt.rgba(0,0,0,0.2) : Qt.rgba(0,0,0,0)

    signal clicked()
    signal rightClicked()

    property var windows: ListUtils.filter(windowManager.windows, function(modelData) {
        return modelData.window.appId == appId
    })

    onClicked: {
        if (!running) {
            appLauncher.listView.model.get(index).launch()
        } else if (focused) {
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

    Ink {
        id: ink
        anchors.fill: parent

        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: {
            print("Clicked!")
            if (mouse.button == Qt.RightButton)
                appLauncher.rightClicked()
            else
                appLauncher.clicked()
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
    }

    AppIcon {
        iconName: desktopFile.iconName
        name: desktopFile && desktopFile.name !== "" ? desktopFile.name : appId
        anchors.centerIn: parent
        width: parent.width * 0.55
        height: width
        opacity: running ? 1 : 0.3

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    Rectangle {
        width: parent.width
        height: Units.dp(2)
        anchors.bottom: parent.bottom
        color: "white"
        visible: focused
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