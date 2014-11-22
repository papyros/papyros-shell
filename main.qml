/*
 * Quartz Shell - The desktop shell for Quartz OS following Material Design
 * Copyright (C) 2014 Michael Spencer
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
import QtQuick 2.2
import Material 0.1

// TODO: Don't subclass from Application, since it actually subclasses QtQuick Window
// However, we do need the theme, units, and other such stuff
MainView {
    id: shell

    property Window currentWindow
    property var windows: []
    property var windowOrder: []

    function windowAdded(window) {
        var windowComponent = Qt.createComponent("Window.qml");
        if (windowComponent.status != Component.Ready) {
            console.warn("Error loading Window.qml: " +  windowComponent.errorString());
            return;
        }
        var window = windowComponent.createObject(desktop);

        window.surface = compositor.item(window);
        window.surface.touchEventsEnabled = true;

        window.surfaceWidth = window.size.width;
        window.surfaceHeight = window.size.height;

        window.x = units.dp(300)
        window.y = units.dp(300)

        windows.push(window)
        windowOrder.push(window)

        print('Window added.')
    }

    function windowResized(window) {
        window.width = window.surface.size.width;
        window.height = window.surface.size.height;

        CompositorLogic.relayout();
    }

    function removeWindow(window) {
        windows = windows.splice(windows.indexOf(window), 1)
        windowOrder = windowOrder.splice(windowOrder.indexOf(window), 1)

        window.destroy();

        print('Window removed.')
    }

    width: units.dp(1440)
    height: units.dp(900)

    theme {
        secondary: "#009688"//"#FFEB3B"
    }

    // TODO: Load the wallpaper from user preferences
    Image {
        id: wallpaper

        anchors.fill: parent
        source: Qt.resolvedUrl("images/quartz_wallpaper.png")
    }

    Panel {
        id: panel
    }

    Column {
        anchors {
            right: parent.right
            top: panel.bottom
            bottom: parent.bottom
            margins: units.dp(25)
        }

        spacing: units.dp(20)

        Label {

            text: "Panel Indicators"
            style: "subheading"
            color: "white"
        }

        Repeater {
            model: panel.indicators
            delegate: Row {
                visible: modelData.icon
                spacing: units.dp(10)

                Icon {
                    name: modelData.icon
                    color: "white"
                }

                Label {
                    text: modelData.tooltip
                    color: "white"
                }
            }
        }
    }

    Item {
        id: desktop

        anchors {
            left: parent.left
            right: parent.right
            top: panel.bottom
            bottom: parent.bottom
        }
    }

    Item {
        id: overlayLayer

        anchors.fill: parent
    }
}
