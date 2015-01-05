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

    property var widgets: ["Music"]

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
            model: widgets
            delegate: Loader {
                source: Qt.resolvedUrl("widgets/%1.qml".arg(modelData))

                anchors {
                    left: parent.left
                    right: parent.right
                    margins: units.dp(16)
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

