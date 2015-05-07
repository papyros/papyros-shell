import QtQuick 2.4
import Material 0.1
import Material.Extras 0.1
import GreenIsland 1.0
import "WindowManagement.js" as WindowManagement

/*
 * The desktop consists of multiple workspaces, one of which is shown at a time. The desktop
 * can also go into exposed-mode,
 */
Item {
    id: desktop

    objectName: "desktop" // Used by the C++ wrapper to hook up the signals

    anchors.fill: parent

    property bool expanded: shell.state == "exposed"

    property Workspace currentWorksace: listView.currentItem

    VisualItemModel {
        id: workspaces

        Workspace { index: 0 }

        Workspace { id: workspace1; index: 1 }
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
        anchors {
            fill: parent
        }

        onTopLeftTriggered: {
            if (desktop.expanded)
                shell.state = "default"
            else
                shell.state = "exposed"
        }
    }

    // ===== Window Management =====

    property var activeWindow: null

    readonly property alias surfaceModel: surfaceModel
    readonly property int activeWindowIndex: WindowManagement.getActiveWindowIndex()
    readonly property var windowList: WindowManagement.windowList

    ListModel {
        id: surfaceModel
    }

    // Code taken from Hawii desktop shell
    Connections {
        target: compositor

        onWindowMapped: {
            // A window was mapped
            WindowManagement.windowMapped(window);
        }
        onWindowUnmapped: {
            // A window was unmapped
            WindowManagement.windowUnmapped(window);
        }
        onWindowDestroyed: {
            // A window was unmapped
            WindowManagement.windowDestroyed(id);
        }
        onShellWindowMapped: {
            // A shell window was mapped
            WindowManagement.shellWindowMapped(window);
        }
    }

    /*
    * Methods
    */

    function moveFront(window) {
        return WindowManagement.moveFront(window);
    }

    function enableInput() {
        var i;
        for (i = 0; i < compositorRoot.surfaceModel.count; i++) {
            var window = compositorRoot.surfaceModel.get(i).item;
            window.child.focus = true;
        }
    }

    function disableInput() {
        var i;
        for (i = 0; i < compositorRoot.surfaceModel.count; i++) {
            var window = compositorRoot.surfaceModel.get(i).item;
            window.child.focus = false;
        }
    }
}
