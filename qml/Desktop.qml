/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 * Copyright (C) 2015 Michael Spencer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.2
import Material 0.1
import Material.Extras 0.1
import "components"

Item {
	id: desktop
	objectName: "desktop" // Used by the C++ wrapper to hook up the signals

	anchors.fill: parent

	property var currentWindow

	property var windows: []
	property var windowOrder: []

	property alias applications: applications

	onCurrentWindowChanged: {
		focusedApplication = applications.applicationForWindow(currentWindow)
	}

	function windowAdded(surface) {
		var windowComponent = Qt.createComponent("Window.qml");
		if (windowComponent.status != Component.Ready) {
			console.warn("Error loading Window.qml: " + windowComponent.errorString());
			return;
		}
		var window = windowComponent.createObject(desktop);

		window.surface = compositor.item(surface);
		window.info = surface;
		window.surface.touchEventsEnabled = true;
		window.surfaceWidth = surface.size.width;
		window.surfaceHeight = surface.size.height;
		window.x = units.dp(100)
		window.y = units.dp(100)
		windows.push(window)
		windowOrder.push(window)

		print(JSON.stringify(surface))

		focusedApplication = applications.addWindow(window)

		windows = windows
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

	property var focusedApplication

	ListModel {
		id: applications

		function applicationForWindow(window) {
			for (var i = 0; i < applications.count; i++) {
				var app = applications.get(i).application

				if (app.desktopFile == window.info.className) {
					return app
				}
			}

			var app = Utils.newObject(Qt.resolvedUrl("Application.qml"), {
				desktopFile: window.info.className
			}, applications)
			append({application: app})

			return app
		}

		function addWindow(window) {
			var app = applicationForWindow(window)

			print('New application!', app.desktopFile)

			app.windows.append(window)

			return app
		}

		function removeWindow(window) {

		}
	}
}
