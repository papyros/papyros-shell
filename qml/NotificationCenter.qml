import QtQuick 2.0
import Material 0.1
import Material.ListItems 0.1 as ListItem
import Material.Desktop 0.1

View {
    fullHeight: true

    elevation: 2
    backgroundColor: "#fafafa"

    property bool showing: false

    anchors {
        right: parent.right
        top: parent.top
        bottom: parent.bottom

        rightMargin: showing ? 0 : -width - units.dp(5)

        Behavior on rightMargin {
            NumberAnimation { duration: 200 }
        }
    }

    width: units.dp(250)

    Column {
        width: parent.width

        spacing: units.dp(16)

        View {
            id: view
            height: label.height + units.dp(16)
            width: parent.width

            Label {
                id: label
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    leftMargin: units.dp(16)
                    rightMargin: units.dp(16)
                }

                text: "Saturday,<br/>November 8<sup>th</sup>"
                style: "title"
                font.pixelSize: units.dp(30)
                textFormat: Text.RichText
            }
        }

        Repeater {
            model: musicPlayer.playerList

            /*
if the playback state is Stopped
a player can't play, pause, next or previous
so you should replace it with an open button
and use the raise function,
*/
            delegate: Card {
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: units.dp(16)
                }

                height: col.implicitHeight + units.dp(16)

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

                        IconAction {
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
                            text: "<b>#%1</b> - %2".arg(model.metadata["mpris:trackid"])
                                                  .arg(model.metadata["xesam:title"])
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

                        IconAction {
                            name: "av/skip_previous"
                            onTriggered: previous()
                        }

                        IconAction {
                            name: "av/pause"
                            onTriggered: playPause()
                        }

                        IconAction {
                            name: "av/skip_next"
                            onTriggered: next()
                        }
                    }
                }
            }
        }
    }

    Item {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: units.dp(16)
        }

        height: childrenRect.height

        Label {
            anchors.verticalCenter: parent.verticalCenter

            text: "Silent mode"
        }

        Switch {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
        }
    }

    MprisConnection {
        id: musicPlayer
    }
}

