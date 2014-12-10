/*
 * Quantum Shell - The desktop shell for Quantum OS following Material Design
 * Copyright (C) 2014 Michael Spencer
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

MainView {
    id: shell

    property Window currentWindow

    property bool overviewMode
    property bool screenLocked

    width: units.dp(1440)
    height: units.dp(900)

    theme {
       	//accentColor: "#009688"//"#FFEB3B"
    }
    
    Component.onCompleted: theme.accentColor = "#009688"

    onOverviewModeChanged: panel.selectedIndicator = null

    // TODO: Load the wallpaper from user preferences
    Image {
        id: wallpaper

        anchors.fill: parent
        source: Qt.resolvedUrl("qrc:/images/quantum_wallpaper.png")
    }

    Item {
        id: desktop

        opacity: screenLocked ? 0 : 1

        Behavior on opacity {
            NumberAnimation {
                duration: 500
            }
        }

        anchors {
            left: parent.left
            right: parent.right
            top: panel.bottom
            bottom: parent.bottom
        }

        InteractiveNotification {
            z: 2
            y: units.dp(20)

            height: units.dp(100)
            width: units.dp(300)

            Row {
                spacing: units.dp(10)

                anchors {
                    left: parent.left
                    top: parent.top
                    margins: units.dp(10)
                }

                Icon {
                    name: "communication/chat"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Label {
                    text: "Test Contact"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        Column {
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
                margins: units.dp(25)
            }

            spacing: units.dp(20)

            Label {

                text: "Panel Indicators"
                style: "subheading"
                color: "white"
            }

            Repeater {
                model: panel.indicators
                delegate: Row {
                    visible: modelData.icon
                    spacing: units.dp(10)

                    Icon {
                        name: modelData.icon
                        color: "white"
                    }

                    Label {
                        text: modelData.tooltip
                        color: "white"
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: screenLocked = !screenLocked
        }
    }

    Item {
        id: overlayLayer

        anchors.fill: parent
        
        opacity: screenLocked ? 0 : 1

        Behavior on opacity {
            NumberAnimation {
                duration: 500
            }
        }
    }
    
    Panel {
        id: panel
    }
    
    Item {
    	anchors {
            left: parent.left
            right: parent.right
            top: panel.bottom
            bottom: parent.bottom
        }

		clip: true
    
		Dock {
			id: dock
		}
	}

    Lockscreen {
        id: lockscreen
    }
}
