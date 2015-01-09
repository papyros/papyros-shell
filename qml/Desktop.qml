import QtQuick 2.2
import Material 0.1


Item {
	id: desktop
	objectName: "desktop" // Used by the C++ wrapper to hook up the signals
	
	anchors.fill: parent
	
	property var currentWindow

	property var windows: []
	property var windowOrder: []
	
	function windowAdded(window) {
		print('Adding window!')
		var windowComponent = Qt.createComponent("Window.qml");
		if (windowComponent.status != Component.Ready) {
			console.warn("Error loading Window.qml: " + windowComponent.errorString());
			return;
		}
		var window = windowComponent.createObject(desktop);
		
		print('Window created!')
		print('Compositor', compositor)
		window.surface = compositor.item(window);
		print('Window surface set up!')
		window.surface.touchEventsEnabled = true;
		window.surfaceWidth = window.size.width;
		window.surfaceHeight = window.size.height;
		window.x = units.dp(300)
		window.y = units.dp(300)
		print('Window set up!')
		windows.push(window)
		windowOrder.push(window)
		print('Window added.')
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
