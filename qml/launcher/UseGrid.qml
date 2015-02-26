import QtQuick 2.0

GridView {
	z: 5
	clip: true
	boundsBehavior: Flickable.StopAtBounds
	model: desktopScrobbler.desktopFiles
	delegate: Item {
	   	width: units.dp(90)
	   	height: units.dp(90)

		Text { text: edit.name}
	}
    cellWidth: units.dp(90)
	cellHeight: units.dp(90)
}