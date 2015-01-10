import QtQuick 2.0
import Material 0.1

Object {
	id: application
	
	property alias windows: windows
	
	property string desktopFile
	property string appName: desktopFile
	property url iconSource
	
	ListModel {
		id: windows
	}
}
