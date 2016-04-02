/*
 * QML Material - An application framework implementing Material Design.
 * Copyright (C) 2014-2015 Michael Spencer <sonrisesoftware@gmail.com>
 *               2015 Jordan Neidlinger <jneidlinger@barracuda.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.0
import QtQuick.Layouts 1.1
import Material 0.3
import Material.ListItems 0.1

/*!
   \qmltype Subtitled
   \inqmlmodule Material.ListItems 0.1

   \brief A list item with a two or three lines of text and optional primary and secondary actions.
 */
BaseListItem {
    id: listItem

    height: Units.dp(100)

    onClicked: raise

    GridLayout {
        anchors.fill: parent

        anchors.leftMargin: listItem.margins
        anchors.rightMargin: listItem.margins

        columns: 4
        rows: 2
        columnSpacing: Units.dp(16)
        rowSpacing: 0

        Image {
            Layout.preferredWidth: Units.dp(40)
            Layout.preferredHeight: width
            source: model.metadata["mpris:artUrl"]
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.column: 2

            spacing: Units.dp(3)

            Label {
                id: label

                Layout.fillWidth: true

                elide: Text.ElideRight
                style: "subheading"
                text: model.metadata["xesam:title"]
            }

            Label {
                id: subLabel

                Layout.fillWidth: true

                color: Theme.light.subTextColor
                elide: Text.ElideRight
                style: "body1"
                text: model.metadata["xesam:album"]
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.column: 2
            Layout.row: 2

            spacing: Units.dp(10)

            IconButton {
                iconName: "av/skip_previous"
                enabled: model.canGoPrevious && model.playbackStatus != "Stopped"
                onClicked: previous()
            }

            IconButton {
                id: playPauseBtn

                iconName: playbackStatus == "Paused" ? "av/play_arrow" : "av/pause"
                enabled: model.playbackStatus != "Stopped"
                onClicked: playPause()
            }

            IconButton {
                iconName: "av/skip_next"
                enabled: model.canGoNext && model.playbackStatus != "Stopped"
                onClicked: next()
            }
        }
    }
}
