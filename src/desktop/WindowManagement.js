/****************************************************************************
 * This file is part of Green Island.
 *
 * Copyright (C) 2014-2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * Author(s):
 *    Pier Luigi Fiorini
 *
 * $BEGIN_LICENSE:GPL2+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

var windowList = new Array(0);
var activeWindow = null;

/*
 * Application windows
 */

function _printWindowInfo(window) {
    console.debug("\twindow:", window);
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
    console.debug("\tscreen:", shell.screenInfo.name);
}

function windowMapped(window) {
    console.debug("Application window mapped");
    _printWindowInfo(window);

    // Create surface item
    var componentName = "ToplevelWindow.qml";
    switch (window.type) {
    case ClientWindow.Popup:
        componentName = "PopupWindow.qml";
        break;
    case ClientWindow.Transient:
        componentName = "TransientWindow.qml";
        break;
    default:
        break;
    }
    var component = Qt.createComponent(componentName);
    if (component.status !== Component.Ready) {
        console.error(component.errorString());
        return;
    }

    // Retrieve the view for this output
    var child = window.viewForOutput(_greenisland_output);

    // Determine the parent
    var parentItem = desktop;
    switch (window.type) {
    case ClientWindow.TopLevel:
        parentItem = desktop//.currentWorkspace
        break;
    case ClientWindow.Popup:
    case ClientWindow.Transient:
        parentItem = window.parentWindow.viewForOutput(_greenisland_output).parent;
        break;
    default:
        break;
    }

    // Create and setup window container
    var item = component.createObject(parentItem, {"clientWindow": window, "child": child});
    item.child.parent = item;
    item.child.anchors.left = Qt.binding(function() { return item.left });
    item.child.anchors.top = Qt.binding(function() { return item.top });
    item.child.touchEventsEnabled = true;
    item.x = child.localX;
    item.y = child.localY;
    item.width = window.size.width;
    item.height = window.size.height;
    console.debug("\titem:", item);
    console.debug("\titem position:", item.x + "," + item.y);

    // Set transient children so that the parent can be desaturated
    if (window.type === ClientWindow.Transient)
        parentItem.transientChildren = item;
    // Set popup child to enable dim effect
    else if (window.type === ClientWindow.Popup)
        parentItem.popupChild = item;

    // Make it visible
    item.visible = true;

    // z-order and focus
    if (window.type === ClientWindow.TopLevel) {
        item.z = windowList.length;
        window.activate();
    }

    // Run map animation
    item.runMapAnimation();

    // Add surface to the model
    surfaceModel.append({"id": window.id, "window": window, "item": item, "surface": window.surface});
}

function windowUnmapped(window) {
    console.debug("Application window unmapped");
    _printWindowInfo(window);

    // Find window representation
    var i, item = null;
    for (i = 0; i < surfaceModel.count; i++) {
        var entry = surfaceModel.get(i);

        if (entry.window === window) {
            item = entry.item;
            break;
        }
    }
    if (!item)
        return;

    // Forget window
    _forgetWindow(i, entry.window, entry.item, false);
}

function windowDestroyed(id) {
    // Find window representation
    var i, found = false, entry = null;
    for (i = 0; i < surfaceModel.count; i++) {
        entry = surfaceModel.get(i);

        if (entry.id === id) {
            found = true;
            break;
        }
    }
    if (!found)
        return;

    // Debug
    console.debug("Application window destroyed");
    _printWindowInfo(entry.window);

    // Forget window
    _forgetWindow(i, entry.window, entry.item, true);
}

/*
 * Window management
 */

function moveFront(window) {
    var initialZ = window.z;

    console.debug("moveFront[" + windowList.length + "] initialZ:", initialZ);
    console.debug("\twindow:", window);

    var i;
    for (i = initialZ + 1; i < windowList.length; ++i) {
        windowList[i].z = window.z;
        window.z = i;
        console.debug("\t\t-> above:", windowList[i].z, "selected:", window.z);
    }
    console.debug("\t\t-> new:", window.z);

    windowList.splice(initialZ, 1);
    windowList.push(window);

    //console.debug("\twindowList:", windowList);
    //console.debug("\twindowList.length:", windowList.length);

    //window.parent.parent.selectWorkspace(window.parent);
    activeWindow = window;
    desktop.activeWindow = activeWindow;

    // Give focus to the window
    window.child.takeFocus();
}

function _forgetWindow(i, window, item, destruction) {
    // Remove from model
    surfaceModel.remove(i);

    // Remove from z-order list
    if (window.type === ClientWindow.TopLevel) {
        for (i = 0; i < windowList.length; ++i) {
            if (windowList[i] === item) {
                windowList.splice(i, 1);
                break;
            }
        }
    }

    // Run animation
    if (destruction)
        item.runDestroyAnimation();
    else
        item.runUnmapAnimation();

    // Unset transient children so that the parent can go back to normal
    // and also bring to front
    if (window.type === ClientWindow.Transient) {
        var parentItem = window.parentWindow.viewForOutput(_greenisland_output).parent;
        parentItem.transientChildren = null;
        parentItem.child.takeFocus();
    }
}

function getActiveWindowIndex() {
    if (!activeWindow)
        return -1;
    return windowList.indexOf(activeWindow);
}
