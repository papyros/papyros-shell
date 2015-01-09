import QtQuick 2.2
import Material 0.1


Item {
	id: desktop
	objectName: "desktop" // Used by the C++ wrapper to hook up the signals
	
	anchors.fill: parent
	
	property var currentWindow

	property var windows: []
	property var windowOrder: []
	
	function windowAdded(surface) {
		var windowComponent = Qt.createComponent("Window.qml");
		if (windowComponent.status != Component.Ready) {
			console.warn("Error loading Window.qml: " + windowComponent.errorString());
			return;
		}
		var window = windowComponent.createObject(desktop);
		
		window.surface = compositor.item(surface);
		window.surface.touchEventsEnabled = true;
		window.surfaceWidth = surface.size.width;
		window.surfaceHeight = surface.size.height;
		window.x = units.dp(100)
		window.y = units.dp(100)
		windows.push(window)
		windowOrder.push(window)
		print('Window added.', window.surfaceWidth, window.surfaceHeight)
	}

	function windowResized(window) {
		window.width = window.surface.size.width;
		window.height = window.surface.size.height;
		CompositorLogic.relayout();
	}

	function removeWindow(window) {
		windows = windows.splice(windows.indexOf(window), 1)
		windowOrder = windowOrder.splice(windowOrder.indexOf(window), 1)
		window.destroy();
		print('Window removed.')
	}
}
