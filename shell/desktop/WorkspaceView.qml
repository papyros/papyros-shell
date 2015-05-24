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

    property alias isCurrentWorkspace: workspace.isCurrentWorkspace

    CrossFadeImage {
        id: wallpaper

        anchors.fill: parent

        fadeDuration: 500
        fillMode: Image.Stretch

        source: {
            var filename = wallpaperSetting.pictureUri

            if (filename.indexOf("xml") != -1) {
                // We don't support GNOME's time-based wallpapers. Default to our default wallpaper
                return Qt.resolvedUrl("../images/papyros_wallpaper.png")
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
    }
}
