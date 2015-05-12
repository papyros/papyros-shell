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
import Material.Desktop 0.1
import "../components"

View {
    id: windowSwitcher

    anchors.centerIn: parent
    elevation: 2
    radius: Units.dp(2)

    height: column.height + Units.dp(16)
    width: column.width + Units.dp(16)

    backgroundColor: Qt.rgba(0.2, 0.2, 0.2, 0.9)

    opacity: showing ? 1 : 0
    visible: opacity > 0

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    property bool showing: shell.state == "switcher"
    property int index
    property bool enabled: count > 0
    property int count: windowManager.orderedWindows.count

    onCountChanged: {
        index = Math.min(index, count - 1)
    }

    onEnabled: {
        if (!enabled && showing)
            dismiss()
    }

    function show() {
        index = 0
        shell.state = "switcher"
    }

    function dismiss() {
        windowManager.moveFront(windowManager.orderedWindows.get(index).item)
        shell.state = "default"
    }

    function next() {
        print("Next!")
        index = (index + 1) % count
    }

    function prev() {
        print("Previ!")
        index = (index - 1) % count
    }

    Column {
        id: column
        anchors.centerIn: parent

        spacing: Units.dp(8)
    
        Row {
            spacing: Units.dp(8)

            Repeater {
                model: windowManager.orderedWindows
                delegate: Rectangle {
                    height: Units.dp(100)
                    width: config.showWindowSwitcherPreviews ? preview.implicitWidth : height

                    color: "transparent"

                    border.color: index == windowSwitcher.index ? "white" : "transparent"
                    border.width: Units.dp(2)
                    radius: Units.dp(2)

                    AppIcon {
                        anchors {
                            fill: parent
                            margins: Units.dp(8) 
                        }

                        iconName: window.iconName
                        name: desktopFile.name !== "" ? desktopFile.name : window.appId
                    }

                    DesktopFile {
                        id: desktopFile
                        appId: window.appId
                    }

                    WindowPreview {
                        id: preview
                        visible: config.showWindowSwitcherPreviews
                        anchors {
                            fill: parent
                            margins: Units.dp(8) 
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.AllButtons
                        onClicked: preview.activate()
                    }
                }
            }
        }

        Label {
            width: parent.width

            horizontalAlignment: Qt.AlignHCenter

            elide: Text.ElideRight

            text: windowManager.orderedWindows.get(windowSwitcher.index).window.title
            style: "subheading"
            color: Theme.dark.textColor
        }
    }
}