/*
 * Quantum Shell - The desktop shell for Quantum OS following Material Design
 * Copyright (C) 2014 Michael Spencer
 * Copyright (C) 2014 Ricardo Vieira <ricardo.vieira@tecnico.ulisboa.pt>
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

import QtQuick 2.3
import Material 0.1
import org.kde.plasma.core 2.0 as PlasmaCore
import ".."

Indicator {
    icon: "hardware/headset"
    tooltip: "Multimedia"

    visible: mpris2Source.sources.length > 1

    dropdown: DropDown {
        implicitHeight:  column.height + units.dp(25)
        Column {
            id: column
            spacing: 5
            width: parent.width - units.dp(25)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: mpris2Source.title
                font.pixelSize: 15
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: mpris2Source.artist
                font.pixelSize: 15
            }
            View {
                elevation: 2
                width: albumArt.width
                height: albumArt.height
                anchors.horizontalCenter: parent.horizontalCenter
                Image {
                    id: albumArt
                    source: mpris2Source.artUrl
                }
            }
            ProgressBar {
                progress: mpris2Source.trackPosition / mpris2Source.trackLength;
                width: parent.width
                Timer {
                    interval: 1000
                    repeat: true
                    running: (mpris2Source.playbackStatus == "Playing")
                    onTriggered: {
                        mpris2Source.trackPosition += 1000000;
                    }
                }
            }
            Row {
                id: mediaControls
                anchors.horizontalCenter: parent.horizontalCenter
                IconAction {
                    name: "av/skip_previous"
                    size: units.dp(48)
                    onTriggered: mpris2Source.previous()
                }
                IconAction {
                    name: (mpris2Source.playbackStatus == "Playing") ? "av/pause" : "av/play_arrow";
                    size: units.dp(48)
                    onTriggered: mpris2Source.playPause()
                }
                IconAction {
                    name: "av/skip_next"
                    size: units.dp(48)
                    onTriggered: mpris2Source.next()
                }
            }
        }
        PlasmaCore.DataSource {
            id: mpris2Source
            engine: "mpris2"
            connectedSources: current
            
            property string current: "@multiplex"
            function action_openplayer() {
                serviceOp(current, "Raise");
            }

            function playPause() {
                serviceOp(current, "PlayPause");
            }

            function previous() {
                serviceOp(current, "Previous");
            }

            function next() {
                serviceOp(current, "Next");
            }

            function serviceOp(src, op) {
                var service = mpris2Source.serviceForSource(src);
                var operation = service.operationDescription(op);
                return service.startOperationCall(operation);
            }
            interval: 0
            property bool hasMetadata: getHasMetadata()
            property string title: getMetadata("xesam:title", '')
            property string artist: getMetadata("xesam:artist", []).join(", ")
            property string album: getMetadata("xesam:album", '')
            property url artUrl: getMetadata("mpris:artUrl", '')
            property int trackLength: getMetadata("mpris:length", 0)
            property string playbackStatus: getHasData() ? data[current]["PlaybackStatus"] : 'unknown'
            property bool canControl: getHasData() && data[current]["CanControl"]
            property int trackPosition: getHasData() ? data[current].Position : 0

            function getHasData() {
                return data[current] != undefined
                    && data[current]["PlaybackStatus"] != undefined;
            }

            function getHasMetadata() {
                return data[current] != undefined
                    && data[current]["Metadata"] != undefined
                    && data[current]["Metadata"]["mpris:trackid"] != undefined;
            }

            function getMetadata(entry, def) {
                if (hasMetadata && data[current]["Metadata"][entry] != undefined)
                    return data[current]["Metadata"][entry];
                else
                    return def;
            }
            onSourceAdded: {
            }

            onSourcesChanged: {
            }

            onDataChanged: {
                trackPosition = getHasData() ? data[current].Position : 0
            }
        }
    }
}