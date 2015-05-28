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

Item {
    id: workspacesView

    property int currentIndex
    property int workspaceWidth: workspaceHeight * width/height
    property int workspaceHeight: flickable.height
    property bool exposed

    property int windowCount: windowManager.windows.count

    onWindowCountChanged: {
        var i = 0
        while (i < windowManager.workspaces.count) {
            var workspace = windowManager.workspaces.get(i).workspace

            if (workspace.windows.count == 0 && i != currentIndex &&
                    windowManager.workspaces.count > 1) {
                removeWorkspace(i)
            } else {
                i++
            }
        }

        currentIndex = Math.min(currentIndex, windowManager.workspaces.count - 1)
        windowManager.currentWorkspace = windowManager.workspaces.get(currentIndex).workspace
    }

    Component.onCompleted: {
        // Start off with one workspace
        addWorkspace()
    }

    function selectWorkspace(workspaceIndex) {
        var i = 0
        while (i < windowManager.workspaces.count) {
            var workspace = windowManager.workspaces.get(i).workspace

            if (workspace.windows.count == 0 && i != workspaceIndex &&
                    windowManager.workspaces.count > 1) {
                if (workspaceIndex > i)
                    workspaceIndex--
                removeWorkspace(i)
            } else {
                i++
            }
        }

        currentIndex = Math.min(workspaceIndex, windowManager.workspaces.count - 1)
        windowManager.currentWorkspace = windowManager.workspaces.get(currentIndex).workspace
    }

    function addWorkspace() {
        workspaceView.createObject(workspacesRow)
    }

    function removeWorkspace(index) {
        print("Removing workspace", index)
        var workspace = windowManager.workspaces.get(index).workspace
        workspace.view.destroy()
        workspace.view.visible = false
        windowManager.removeWorkspace(index)
    }

    Row {
        id: previewRow

        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: Units.dp(16) + stage.item.bottomMargin
        }

        spacing: Units.dp(32)
        height: Units.dp(75)

        Repeater {
            model: windowManager.workspaces
            delegate: WorkspacePreview {}
        }

        WorkspacePreview {
            visible: windowManager.workspaces.get(windowManager.workspaces.count - 1)
                    .workspace.windows.count > 0

            // This variable must exist but be undefined
            property var workspace
        }
    }

    Flickable {
        id: flickable
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            bottom: parent.bottom

            topMargin: exposed ? Units.dp(32) : 0
            bottomMargin: exposed
                    ? Units.dp(32) + previewRow.height + previewRow.anchors.bottomMargin : 0

            Behavior on topMargin {
                NumberAnimation { duration: 300 }
            }

            Behavior on bottomMargin {
                NumberAnimation { duration: 300 }
            }
        }

        width: workspaceWidth

        interactive: false
        contentX: currentIndex * (workspaceWidth + workspacesRow.spacing)
        contentWidth: workspacesRow.width
        contentHeight: workspaceHeight

        Row {
            id: workspacesRow

            spacing: Units.dp(64)
        }
    }

    Component {
        id: workspaceView

        WorkspaceView {
            width: workspaceWidth
            height: workspaceHeight
        }
    }
}
