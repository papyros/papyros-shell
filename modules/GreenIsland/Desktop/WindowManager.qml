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
import QtQuick 2.3
import GreenIsland 1.0
import GreenIsland.Desktop 1.0

Item {
    id: windowManager

    signal selectWorkspace(var workspace)

    property Component topLevelWindowComponent: TopLevelWindow {}
    property Component popupWindowComponent: PopupWindow {}
    property Component transientWindowComponent: TransientWindow {}

    readonly property bool usesWorkspaces: currentWorkspace != null
    property Workspace currentWorkspace: defaultWorkspace

    readonly property var activeWindow: currentWorkspace.activeWindow

    property alias workspaces: workspaces
    property alias windows: windows
    property alias surfaces: surfaces
    property alias orderedWindows: orderedWindows
    property alias screenInfo: screenInfo

    onSelectWorkspace: currentWorkspace = workspace

    WindowListModel {
        id: surfaces

        function add(window) {
            surfaces.append({
                "id": window.clientWindow.id,
                "window": window.clientWindow,
                "item": window,
                "surface": window.clientWindow.surface,
                "workspace": currentWorkspace
            });

            if (window.clientWindow.type == ClientWindow.TopLevel) {
                windows.append({
                    "id": window.clientWindow.id,
                    "window": window.clientWindow,
                    "item": window,
                    "surface": window.clientWindow.surface,
                    "workspace": currentWorkspace
                });

                orderedWindows.insert(0, {
                    "id": window.clientWindow.id,
                    "window": window.clientWindow,
                    "item": window,
                    "surface": window.clientWindow.surface,
                    "workspace": currentWorkspace
                });

                currentWorkspace.windows.append({
                    "id": window.clientWindow.id,
                    "window": window.clientWindow,
                    "item": window,
                    "surface": window.clientWindow.surface,
                    "workspace": currentWorkspace
                });

                currentWorkspace.orderedWindows.insert(0, {
                    "id": window.clientWindow.id,
                    "window": window.clientWindow,
                    "item": window,
                    "surface": window.clientWindow.surface,
                    "workspace": currentWorkspace
                });
            }
        }

        function removeWindow(window) {
            print("Forgetting window", window.clientWindow.id)

            var id = window.clientWindow.id
            window.destroyed = true
            if (window.parent && window.parent.transientChildren)
                window.parent.transientChildren = null;
            if (window.parent && window.parent.popupChild)
                window.parent.popupChild = null;
            window.workspace.windows.removeById(id)
            window.workspace.orderedWindows.removeById(id)
            surfaces.removeById(id)
            windows.removeById(id)
            orderedWindows.removeById(id)

            if (window.clientWindow.maximized)
                window.parent.maximizedCount--
            print("WINDOW REMOVED!!")
        }
    }

    WindowListModel {
        id: windows
    }

    WindowListModel {
        id: orderedWindows
    }

    ListModel {
        id: workspaces

        onCountChanged: {
            for (var i = 0; i < workspaces.count; i++) {
                workspaces.get(i).workspace.index = i
            }
        }
    }

    Workspace {
        id: defaultWorkspace
        anchors.fill: parent

        __defaultWorkspace: true
        visible: !usesWorkspaces
    }

    function removeWorkspace(index) {
        workspaces.remove(index, 1)
    }

    function sourceForIconName(iconName) {
        if (iconName.indexOf("/") != -1)
            return iconName
        else if (iconName != "")
            return "image://desktoptheme/" + iconName;
        else
            return "";
    }

    function _printWindowInfo(window) {
        console.debug("\twindow:", window);
        console.debug("\tid:", window.id);
        console.debug("\tsurface:", window.surface);
        console.debug("\tappId:", window.appId);
        console.debug("\ttitle:", window.title);
        console.debug("\tposition:", window.x + "," + window.y);
        console.debug("\tsize:", window.size.width + "x" + window.size.height);

        switch (window.type) {
            case ClientWindow.TopLevel:
                console.debug("\ttype: TopLevel");
                break;
            case ClientWindow.Popup:
                console.debug("\ttype: Popup");
                break;
            case ClientWindow.Transient:
                console.debug("\ttype: Transient");
                break;
            default:
                break;
        }

        console.debug("\tparentWindow:", window.parentWindow);
        console.debug("\tscreen:", screenInfo.name);
    }

    // TODO: Handle fullscreen windows
    function windowMapped(window) {
        var component = null
        var parentItem

        // Retrieve the view for this output
        var child = window.viewForOutput(_greenisland_output);

        switch (window.type) {
            case ClientWindow.TopLevel:
                component = windowManager.topLevelWindowComponent;
                parentItem = currentWorkspace
                break;
            case ClientWindow.Popup:
                component = windowManager.popupWindowComponent;
                parentItem = window.parentViewForOutput(_greenisland_output).parent;
                break;
            case ClientWindow.Transient:
                component = windowManager.transientWindowComponent;
                parentItem = window.parentViewForOutput(_greenisland_output).parent;
                break;
            default:
                console.error("Unknown window type", window.type);
                return;
        }

        // Create and setup window container
        var item = component.createObject(parentItem, {
            "clientWindow": window, "child": child,
            "windowManager": windowManager,
            "workspace": currentWorkspace
        });

        // TODO: Animate the window, or show a fullscreen workspace

        surfaces.add(item)

        if (window.type == ClientWindow.TopLevel)
            currentWorkspace.activeWindow = item
    }

    function windowUnmapped(window) {
        var entry = surfaces.findByWindow(window)

        if (!entry) return;

        console.debug("Application window unmapped");
        _printWindowInfo(window);

        surfaces.removeWindow(entry.item);
    }

    function windowDestroyed(id) {
        var entry = surfaces.findById(id)

        if (!entry) return;

        console.debug("Application window destroyed");
        _printWindowInfo(entry.window);

        surfaces.removeWindow(entry.item);
    }

    /*
     * Window management
     */

    function moveFront(window) {
        var workspace = window.workspace

        workspace.moveFront(window)
    }

    function enableInput() {
        var i;
        for (i = 0; i < windowManager.surfaces.count; i++) {
            var window = windowManager.surfaces.get(i).item;
            window.child.focus = true;
        }
    }

    function disableInput() {
        var i;
        for (i = 0; i < windowManager.surfaces.count; i++) {
            var window = windowManager.surfaces.get(i).item;
            window.child.focus = false;
        }
    }

    function focusApplication(appId) {
        var i, entry;
        var workspace
        for (var i = 0; i < windows.count; i++) {
            var entry = windows.get(i);
            if (entry.window.appId === appId) {
                if (entry.window.minimized)
                    entry.window.unminimize();
                if (!entry.window.active)
                    entry.window.activate();
                if (workspace != currentWorkspace)
                    workspace = entry.item.workspace
            }
        }

        if (workspace != currentWorkspace)
            selectWorkspace(workspace)
    }

    Connections {
        target: Compositor

        onWindowMapped: windowManager.windowMapped(window);
        onWindowUnmapped: windowManager.windowUnmapped(window);
        onWindowDestroyed: windowManager.windowDestroyed(id);
    }

    QtObject {
        id: screenInfo

        readonly property string name: _greenisland_output.name
        readonly property int number: _greenisland_output.number
        readonly property bool primary: _greenisland_output.primary
    }
}
