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

View {
    id: workspacePreview

    backgroundColor: "#555"
    tintColor: ink.containsMouse ? Qt.rgba(1,1,1,0.1) : Qt.rgba(1,1,1,0)
    elevation: 2
    radius: Units.dp(2)

    height: parent.height
    width: height

    Ink {
        id: ink
        anchors.fill: parent
        onClicked: {
            if (workspace) {
                workspacesView.selectWorkspace(index)
                shell.state = "default"
            } else {
                addWorkspace()
                workspacesView.selectWorkspace(windowManager.workspaces.count - 1)
                shell.state = "default"
            }
        }
    }

    Grid {
        id: grid
        anchors {
            fill: parent
            margins: Units.dp(8)
        }

        columns: workspace ? Math.ceil(Math.sqrt(workspace.windows.count)) : 0
        rows: columns

        columnSpacing: Units.dp(8)
        rowSpacing: columnSpacing

        Repeater {
            model: workspace ? workspace.windows : []
            delegate: AppIcon {
                iconName: window.iconName
                name: window.appId
                width: (grid.width - (grid.columns - 1) * grid.columnSpacing)/grid.columns
                height: width
            }
        }
    }    

    Icon {
        anchors.centerIn: parent
        name: "content/add"
        color: Theme.dark.iconColor
        visible: !workspace || workspace.windows.count == 0
    }
}