import QtQuick 2.0
import Material 0.1
import Material.ListItems 0.1 as ListItem
import Material.Desktop 0.1
import Material.Extras 0.1

Column {
    spacing: units.dp(16)

    Repeater {
        model: musicPlayer.playerList

        /*
    if the playback state is Stopped
    a player can't play, pause, next or previous
    so you should replace it with an open button
    and use the raise function,
    */
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
                        name: "navigation/more_vert"
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

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter

                    spacing: units.dp(10)

                    IconButton {
                        name: "av/skip_previous"
                        onTriggered: previous()
                    }

                    IconButton {
                        name: "av/pause"
                        onTriggered: playPause()
                    }

                    IconButton {
                        name: "av/skip_next"
                        onTriggered: next()
                    }
                }
            }
        }
    }
    MprisConnection {
        id: musicPlayer
    }
}
