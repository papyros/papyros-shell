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
import QtQuick 2.3
import Material 0.1
import Material.ListItems 0.1 as ListItem

View {
    id: indicator

    property alias iconSource: icon.source
    property string tooltip

    signal clicked()
    signal rightClicked()

    property var app

    property bool focused: desktop.focusedApplication == application

    property DropDown popupMenu: DropDown {
        height: column.height
        width: units.dp(250)

        Column {
            id: column
            width: parent.width

            ListItem.Standard {
                text: "New Window"
                showDivider: true
            }

            ListItem.Standard {
                text: "Pinned to dock"

                onTriggered: checkbox.checked = !checkbox.checked

                Switch {
                    id: checkbox
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        rightMargin: (parent.height - height)/2
                    }
                }
            }
        }
    }

    onRightClicked: {
        // Show the right-click menu

        if (tooltip.showing)
            tooltip.close()

        if (popupMenu) {
            if (!popupMenu.showing) {
                popupMenu.open(indicator)
            } else {
                popupMenu.close()
            }
        }
    }

    onClicked: {
        // If the application is open,
        if (app.windows.count > 0) {
            print("App is open")
        	if (focused) {
                print("Spreading windows...")
        		// Window spread!
                desktop.spread(app.windows)
        	} else {
        		// Focus the application
                    print("Focusing the app...")
        	}
        } else {
        	// Launch the application
            print ("Launching the app")
        }
    }

    opacity: screenLocked ? 0 : 1

    height: parent.height
    width: height

    backgroundColor: "transparent"
    tintColor: mouseArea.containsMouse ? Qt.rgba(0,0,0,0.2) : "transparent"

    Behavior on opacity {
        NumberAnimation {
            duration: 250
        }
    }

    Behavior on width {
        NumberAnimation {
            duration: 250
        }
    }

    Image {
        id: icon

        anchors.centerIn: parent

        width: parent.width - units.dp(24)
        height: width * sourceSize.height/sourceSize.width

        mipmap: true
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        onClicked: {
            print("Clicked!")
            if (mouse.button == Qt.RightButton)
                indicator.rightClicked()
            else
                indicator.clicked()
        }

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        hoverEnabled: true

        onContainsMouseChanged: {
            if (!tooltip.text || selectedIndicator != null) return

            if (containsMouse) {
                if (!tooltip.showing)
                    tooltip.open(indicator)
            } else {
                if (tooltip.showing)
                    tooltip.close()
            }
        }
    }

    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom

            //bottomMargin: selected ? 0 : -height
        }

        opacity: focused ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }

        height: units.dp(2)
        color: "white"
    }

    Tooltip {
        id: tooltip

        text: indicator.tooltip
    }
}
