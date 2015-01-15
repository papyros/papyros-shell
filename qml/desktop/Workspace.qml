import QtQuick 2.2
import Material 0.1
import "../components"

View {
    elevation: 5
    width: listView.width
    height: listView.height

    MouseArea {
        anchors.fill: parent

        enabled: desktop.expanded
        onClicked: desktop.expanded = false
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
                return Qt.resolvedUrl("../images/quantum_wallpaper.png")
            } else {
                return filename
            }
        }
    }
}
