/*
 * This file is part of Green Island
 *
 * Copyright (C) 2015 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.0
import GreenIsland 1.0
import GreenIsland.Desktop 1.0

Item {
    id: workspace

    width: windowManager.width
    height: windowManager.height

    property int index: -1
    property bool isCurrentWorkspace

    property string title: "Desktop " + (index + 1)

    property alias windows: windows
    property alias orderedWindows: orderedWindows
    property var activeWindow

    property int maximizedCount
    readonly property bool hasMaximizedWindow: maximizedCount > 0

    property bool __defaultWorkspace: false

    onIsCurrentWorkspaceChanged: {
        if (isCurrentWorkspace)
            windowManager.currentWorkspace = workspace
    }

    Component.onCompleted: {
        if (__defaultWorkspace)
            return

        if (windowManager.workspaces.count == 0)
            windowManager.currentWorkspace = workspace

        if (index == -1)
            index = windowManager.workspaces.count

        windowManager.workspaces.append({"workspace": workspace})
    }

    function moveFront(window) {
        print("Moving", window, "to", workspace.title)
        orderedWindows.moveFront(window)
        windowManager.orderedWindows.moveFront(window)

        orderedWindows.updateOrder()

        windowManager.selectWorkspace(workspace);

        if (window.clientWindow.type == ClientWindow.TopLevel) {
            activeWindow = window;
        }

        // Give focus to the window
        window.child.takeFocus();
        window.clientWindow.activate();
    }

    function forgetWindow(window, destruction) {
        print("Forgetting window", window.clientWindow.id)

        windowManager.surfaces.removeWindow(window);

        window.close()

        // Activate previous top level window

        if (orderedWindows.count > 0) {
            var newWindow = orderedWindows.get(0)

            print("FOCUSING WINDOW")
            newWindow.item.clientWindow.activate();
            windowManager.selectWorkspace(newWindow.workspace);
        }

        windowManager.orderedWindows.updateOrder()
        orderedWindows.updateOrder()

        // TODO: Remove fullscreen workspace, if applicable

        // Unset transient children so that the parent can go back to normal
        // and also bring the parent to front
        if (window.clientWindow.type === ClientWindow.Transient) {
            var parentWindow = window.parentWindow;
            if (parentWindow) {
                var parentItem = parentWindow.viewForOutput(_greenisland_output).parent;
                parentItem.transientChildren = null;
                parentItem.clientWindow.activate();
            }
        }
    }

    WindowListModel {
        id: windows
    }

    WindowListModel {
        id: orderedWindows
    }
}
