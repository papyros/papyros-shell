import QtQuick 2.2
import Material 0.1
import "../components"

View {
    elevation: 5
    width: listView.width
    height: listView.height

    property int index

    property alias windows: content

    MouseArea {
        anchors.fill: parent

        enabled: desktop.expanded
        onClicked: {
            desktop.switchToWorkspace(index)
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
                return Qt.resolvedUrl("../../images/quantum_wallpaper.png")
            } else {
                return filename
            }
        }
    }

    Item {
        id: content
        width: listView.width
        height: listView.height

        anchors.centerIn: parent

        scale: parent.width/width

        clip: true
    }
}
