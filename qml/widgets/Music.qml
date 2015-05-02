/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 * Copyright (C) 2015 Michael Spencer
 *               2015 Bogdan Cuza
 *               2015 Ricardo Vieira
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
import Material 0.1
import Material.Desktop 0.1

Column {
    spacing: units.dp(16)

    Repeater {
        model: musicPlayer.playerList

        delegate: Card {
            width: parent.width

            Column {
                id: col
                anchors.fill: parent
                anchors.margins: units.dp(8)
                spacing: units.dp(8)

                Item {
                    height: childrenRect.height
                    width: parent.width

                    Label {
                        style: "title"
                        text: name
                        color: Theme.light.subTextColor
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    IconButton {
                        iconName: "navigation/more_vert"
                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: parent.right
                        }
                    }
                }

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width * 1/2
                    height: width
                    source: model.metadata["mpris:artUrl"]
                }

                Row {
                    spacing: units.dp(10)
                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    Icon {
                        id: icon
                        name: "image/audiotrack"
                        size: units.dp(15)
                    }

                    Label {
                        text: model.metadata["xesam:title"]
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                        anchors.top: parent.top
                        anchors.topMargin: (icon.height - albumLabel.height)/2

                        width: parent.width - icon.width - units.dp(10)
                    }
                }

                Row {
                    spacing: units.dp(10)

                    Icon {
                        name: "av/album"
                        size: units.dp(15)

                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Label {
                        id: albumLabel
                        text: model.metadata["xesam:album"]

                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                //TODO: Add a slider

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter

                    spacing: units.dp(10)
                    opacity: playbackStatus == "Stopped" ? 0 : 1
                    height: playbackStatus == "Stopped" ? 0 : playPauseBtn.height

                    IconButton {
                        iconName: "av/skip_previous"
                        onClicked: previous()
                        enabled: canGoPrevious
                    }

                    IconButton {
                        id: playPauseBtn

                        iconName: playbackStatus == "Paused" ? "av/play_arrow" : "av/pause"
                        onClicked: playPause()
                    }

                    IconButton {
                        iconName: "av/skip_next"
                        onClicked: next()
                        enabled: canGoNext
                    }
                }

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity: playbackStatus == "Stopped" ? 1 : 0
                    text: "Open"
                    onClicked: raise()
                }
            }
        }
    }
    MprisConnection {
        id: musicPlayer
    }
}
