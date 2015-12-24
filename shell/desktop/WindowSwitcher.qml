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
import Papyros.Components 0.1
import Papyros.Desktop 0.1

Item {
    id: windowSwitcher

    anchors {
        fill: parent
        leftMargin: stage.item.leftMargin
        rightMargin: stage.item.rightMargin
        topMargin: stage.item.topMargin
        bottomMargin: stage.item.bottomMargin
    }

    opacity: showing ? 1 : 0
    visible: opacity > 0

    property bool showing: shell.state == "switcher"
    property int index
    property bool enabled: count > 0
    property int count: repeater.count

    onIndexChanged: print("INDEX", index)

    onCountChanged: {
        index = Math.min(index, count - 1)
        if (count == 0)
            dismiss()
    }

    onEnabled: {
        if (!enabled && showing)
            dismiss()
    }

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    function show() {
        index = 0
        windowView.index = 0
        shell.state = "switcher"
    }

    function dismiss(appId, item) {
        if (appId != undefined) {
            windowManager.focusApplication(appId)
        } else if (item != undefined) {
            windowManager.moveFront(item)
        } else {
            var window = windowView.windows[windowView.index]
            if (window) {
                var item = window.item
                windowManager.moveFront(item)
            }
        }

        shell.state = "default"
    }

    function next() {
        print("Next!")
        index = (index + 1) % count
        windowView.index = 0
        windowView.visible = false
    }

    function prev() {
        print("Previ!")
        index = (index - 1) % count
        windowView.index = 0
        windowView.visible = false
    }

    function nextWindow() {
        print("Next!")
        windowView.visible = true

        var selectedAppId = AppSwitcherModel.get(windowSwitcher.index).appId
        var windows = ListUtils.filter(windowManager.orderedWindows, function(modelData) {
            return modelData.window.appId == selectedAppId
        })

        windowView.index = (windowView.index + 1) % windows.length
    }

    function prevWindow() {
        print("Previ!")
        windowView.visible = true

        var selectedAppId = AppSwitcherModel.get(windowSwitcher.index).appId
        var windows = ListUtils.filter(windowManager.orderedWindows, function(modelData) {
            return modelData.window.appId == selectedAppId
        })

        windowView.index = (windowView.index - 1) % windows.length
    }

    function showWindowsView() {
        windowView.visible = true
    }

    View {
        id: switcher

        anchors.centerIn: parent
        elevation: 2
        radius: Units.dp(2)

        height: column.height + Units.dp(16)
        width: column.width + Units.dp(16)

        backgroundColor: Qt.rgba(0.2, 0.2, 0.2, 0.9)

        Column {
            id: column
            anchors.centerIn: parent

            spacing: Units.dp(8)

            Row {
                id: appRow
                spacing: Units.dp(8)

                Repeater {
                    id: repeater
                    model: AppSwitcherModel
                    delegate: Rectangle {
                        height: Units.dp(100)
                        width: height

                        color: "transparent"

                        border.color: index == windowSwitcher.index ? "white" : "transparent"
                        border.width: Units.dp(2)
                        radius: Units.dp(2)

                        AppIcon {
                            anchors {
                                fill: parent
                                margins: Units.dp(8)
                            }

                            iconName: desktopFile.iconName
                            hasIcon: desktopFile.hasIcon
                            name: desktopFile.name !== "" ? desktopFile.name : appId
                        }

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.AllButtons
                            onClicked: dismiss(appId)
                        }
                    }
                }
            }

            Label {
                width: parent.width

                horizontalAlignment: Qt.AlignHCenter

                elide: Text.ElideRight

                text: count == 0 ? "" : AppSwitcherModel.get(windowSwitcher.index).desktopFile.name
                style: "subheading"
                color: Theme.dark.textColor
            }
        }
    }

    View {
        id: windowView
        anchors {
            top: switcher.bottom
            bottom: parent.bottom
            margins: Units.dp(16)
        }

        visible: false

        x: {
            var appX = windowSwitcher.index * (appRow.height + appRow.spacing) + appRow.height/2
            var x = (switcher.x + Units.dp(8) + appX) - windowView.width/2

            return Math.max(x, Units.dp(16))
        }

        width: windowsRow.width + Units.dp(32)

        elevation: 2
        radius: Units.dp(2)

        backgroundColor: Qt.rgba(0.2, 0.2, 0.2, 0.9)

        property int index
        property int count: windows.length

        property string selectedAppId: windowSwitcher.count > 0 && windowSwitcher.visible
                ? AppSwitcherModel.get(windowSwitcher.index).appId : ""

        property var windows: ListUtils.filter(windowManager.orderedWindows, function(modelData) {
            return modelData.window.appId == selectedAppId
        })

        Row {
            id: windowsRow

            anchors.centerIn: parent

            height: parent.height - Units.dp(32)

            visible: windowView.windows.length > 0
            spacing: Units.dp(16)

            Repeater {
                model: windowView.windows

                delegate: Rectangle {
                    color: "transparent"

                    border.color: index == windowView.index ? "white" : "transparent"
                    border.width: Units.dp(2)
                    radius: Units.dp(2)

                    height: parent.height
                    width: preview.width + Units.dp(16)

                    WindowPreview {
                        id: preview

                        anchors.centerIn: parent

                        height: parent.height - Units.dp(16)
                        width: item.width * height/item.height

                        property var item: modelData.item
                        property var window: modelData.window
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.AllButtons
                        onClicked: {
                            dismiss(selectedAppId, item)
                        }
                    }
                }
            }
        }
    }
}
