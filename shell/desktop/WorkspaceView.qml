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

/*!
   The workspace view holds the workspace wallpaper as well as the workspace itself.
 */
View {
    id: workspaceView

    elevation: 3

    property int spacing: {
        if (workspace.windows.count <= 2) {
            return Units.dp(32)
        } else if (workspace.windows.count == 3) {
            return Units.dp(16)
        } else {
            return Units.dp(8)
        }
    }

    property int windowCount: workspace.windows.count

    onWindowCountChanged: {
        if (workspacesView.exposed)
            spreadWindows()
    }

    function spreadWindows() {
        var layout = layoutWindows()

        var windowIndex = 0

        print(JSON.stringify(layout))

        var rowHeight = (workspace.height - spacing)/layout.count - spacing
        var totalHeight = (rowHeight + spacing) * layout.rows.length + spacing
        var offsetY = (workspace.height - totalHeight)/2

        layout.rows.forEach(function (row) {
            print(JSON.stringify(row))
            var offsetX = (workspace.width - row.width)/2

            row.windows.forEach(function(position) {
                var entry = workspace.windows.get(windowIndex++)

                entry.item.x = position.x + offsetX - (1 - position.scale) * entry.item.width/2
                entry.item.y = position.y + offsetY - (1 - position.scale) * entry.item.height/2
                entry.item.scale = position.scale
            })
        })
    }

    function restoreWindows() {
        for (var i = 0; i < workspace.windows.count; i++) {
            var entry = workspace.windows.get(i)

            entry.item.x = Qt.binding(function() {
                 return entry.item.child ? entry.item.child.localX : 0
            })
            entry.item.y = Qt.binding(function() {
                return entry.item.child ? entry.item.child.localY : 0
            })
            entry.item.width = Qt.binding(function() {
                return entry.item.clientWindow ? entry.item.clientWindow.size.width : 0
            })
            entry.item.height = Qt.binding(function() {
                return entry.item.clientWindow ? entry.item.clientWindow.size.height : 0
            })
            entry.item.scale = 1
        }
    }

    function layoutWindows() {
        var rows = 1
        var layout

        do {
            layout = tryLayout(rows++)
        } while (layout == undefined)

        return layout
    }

    function tryLayout(rows) {
        var rowHeight = (workspace.height - spacing)/rows - spacing
        var rowWidth = spacing
        var row = 0
        var rowList = []
        var list = []

        for (var i = 0; i < workspace.windows.count; i++) {
            var entry = workspace.windows.get(i)
            var windowWidth = rowHeight * entry.item.width/entry.item.height

            if (rowHeight/entry.item.height > 1)
                return undefined

            if (rowWidth + windowWidth + spacing > workspace.width) {
                list.push({
                    "width": rowWidth,
                    "windows": rowList
                })

                rowWidth = spacing
                rowList = []
                row++
            }

            rowList.push({
                x: rowWidth,
                y: spacing + (rowHeight + spacing) * row,
                scale: rowHeight/entry.item.height
            })

            rowWidth += windowWidth + spacing

            if (row >= rows)
                return undefined
        }

        list.push({
            "width": rowWidth,
            "windows": rowList
        })

        return {
            "count": rows,
            "rows": list
        }
    }

    Connections {
        target: workspacesView

        onExposedChanged: {
            if (exposed) {
                spreadWindows()
            } else {
                restoreWindows()
            }
        }
    }

    CrossFadeImage {
        id: wallpaper

        anchors.fill: parent

        fadeDuration: 500
        fillMode: Image.Stretch

        source: {
            var filename = wallpaperSetting.pictureUri

            if (filename.indexOf("xml") != -1) {
                // We don't support GNOME's time-based wallpapers. Default to our default wallpaper
                return Qt.resolvedUrl("../images/papyros-wallpaper.png")
            } else {
                return filename
            }
        }

        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }
    }

    Workspace {
        id: workspace

        scale: parent.width/width
        anchors.centerIn: parent

        property alias view: workspaceView
    }

    MouseArea {
        anchors.fill: parent
        enabled: workspacesView.exposed
        hoverEnabled: enabled

        onWheel: wheel.accepted = true
    }
}
