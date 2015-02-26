import QtQuick 2.0
import Material.ListItems 0.1 as ListItem

ListView {
    z: 5
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    model: desktopScrobbler.desktopFiles
    delegate: ListItem.Subtitled {
        onTriggered: edit.launch()
        text: edit.localizedName || edit.name
        subText: edit.localizedComment || edit.comment
	}
}