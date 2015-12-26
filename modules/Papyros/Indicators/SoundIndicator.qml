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
import Material 0.1
import Material.ListItems 0.1 as ListItem

Indicator {
    id: indicator

    iconName: sound.iconName
    tooltip: sound.muted || sound.master == 0 ? "Muted" : "Volume at %1%".arg(sound.master)

    view: Column {

        ListItem.Subtitled {
            text: qsTr("Volume")
            valueText: sound.muted || sound.master == 0 ? qsTr("Muted") : sound.master + "%"
            content: Slider {
                id: soundslider

                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: Units.dp(7)

                minimumValue: 0
                maximumValue: 100

                value: sound.muted ? 0 : sound.master

                onValueChanged: {
                    if (value != sound.master) {
                        sound.muted = value == 0
                        sound.master = value
                        value = Qt.binding(function() {
                            return sound.muted ? 0 : sound.master
                        })
                    }
                }
            }

            showDivider: musicRepeater.count > 0
        }

        Repeater {
            id: musicRepeater
            model: musicPlayer.playerList
            delegate: Column {
                width: parent.width
                visible: model.metadata["xesam:title"] != undefined

                ListItem.Subheader {
                    text: name
                }

                MusicPlayerListItem {}
            }
        }
    }
}
