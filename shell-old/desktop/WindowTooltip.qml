/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 * Copyright (C) 2015 Michael Spencer
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
import QtQuick 2.0
import QtQuick.Layouts 1.0
import Material 0.1
import GreenIsland.Desktop 1.0

Tooltip {
    id: dropdown

    property var windows: []
    property var app

    ColumnLayout {
        id: layout
        anchors.centerIn: parent

        spacing: Units.dp(16)

        Row {
            Layout.fillHeight: true
            Layout.fillWidth: true

            visible: windows.length > 0
            spacing: Units.dp(16)

            Repeater {
                model: windows

                WindowPreview {
                    id: preview

                    height: Units.dp(100)
                    width: item.width * height/item.height

                    property var item: modelData.item
                    property var window: modelData.window
                }
            }
        }

        Label {
            id: tooltipLabel
            Layout.alignment: Qt.AlignHCenter
            text: {
                if (!app)
                    return ""
                else if (app.desktopFile.name !== "")
                    return app.desktopFile.name
                else
                    return app.appId
            }
            color: Theme.dark.textColor
            style: "subheading"
        }
    }

    width: windows.length == 0
            ? tooltipLabel.paintedWidth + Units.dp(32)
            : layout.width + Units.dp(32)
    height: windows.length == 0
            ? Device.isMobile ? Units.dp(44) : Units.dp(40)
            : layout.height + Units.dp(32)
}
