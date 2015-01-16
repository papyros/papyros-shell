import QtQuick 2.4
import Material 0.1

/*
 * The desktop consists of multiple workspaces, one of which is shown at a time. The desktop
 * can also go into exposed-mode,
 */
Item {
    id: desktop

    objectName: "desktop" // Used by the C++ wrapper to hook up the signals

    anchors.fill: parent

    property bool expanded: shell.state == "exposed"

    VisualItemModel {
        id: workspaces

        Workspace { index: 0 }

        Workspace { index: 1 }
    }

    property real verticalOffset: height * 0.1
    property real horizontalOffset: width * 0.1

    function switchToWorkspace(workspace) {
        print("Switching to index: ", workspace, listView.currentIndex)

        if (workspace == listView.currentIndex) {
            print("Switching to default!")
            shell.state = "default"
        } else {
            listView.currentIndex = workspace
        }
    }

    ListView {
        id: listView
        anchors {
            fill: parent
            leftMargin: expanded ? horizontalOffset : 0
            rightMargin: expanded ? horizontalOffset : 0
            topMargin: expanded ? verticalOffset : 0
            bottomMargin: expanded ? verticalOffset : 0

            Behavior on leftMargin {
                NumberAnimation { duration: 300 }
            }

            Behavior on rightMargin {
                NumberAnimation { duration: 300 }
            }

            Behavior on topMargin {
                NumberAnimation { duration: 300 }
            }

            Behavior on bottomMargin {
                NumberAnimation { duration: 300 }
            }
        }

        displayMarginBeginning: horizontalOffset
        displayMarginEnd: horizontalOffset

        snapMode: ListView.SnapOneItem

        orientation: Qt.Horizontal
        interactive: desktop.expanded
        highlightFollowsCurrentItem: true
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 500
        currentIndex: 0

        spacing: expanded ? horizontalOffset * 0.70 : 0

        Behavior on spacing {
            NumberAnimation { duration: 300 }
        }

        model: workspaces
    }

    HotCorners {
        anchors.fill: parent

        onTopLeftTriggered: {
            if (desktop.exposed)
                shell.state = "default"
            else
                shell.state = "exposed"
        }
    }

    // ===== Window Management =====

    property var currentWindow

	property var windows: []
	property var windowOrder: []

	property alias applications: applications

	onCurrentWindowChanged: {
		focusedApplication = applications.applicationForWindow(currentWindow)
	}

    function spreadWindows(windows) {

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
