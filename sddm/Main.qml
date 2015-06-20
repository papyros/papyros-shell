/*
* Papyros SDDM theme - The SDDM theme for Papyros following Material Design
* Copyright (C) 2015 Michael Spencer <sonrisesoftware@gmail.com>
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
import QtQuick 2.0
import QtQuick.Layouts 1.1
import Material 0.1
import Material.ListItems 0.1 as ListItem
import Material.Extras 0.1
import Papyros.Desktop 0.1
import org.kde.kcoreaddons 1.0 as KCoreAddons

MainView {
	anchors.fill: parent

	theme.primaryColor: Palette.colors["blue"]["500"]
	theme.accentColor: Palette.colors["blue"]["500"]

	Repeater {
		model: screenModel

		Image {
			x: geometry.x; y: geometry.y; width: geometry.width; height:geometry.height
			source: "wallpaper.png"
		}
	}

	property int selectedUser: -1

	Item {
		id: primaryScreen

		anchors.fill: parent

		property var geometry: screenModel.geometry(screenModel.primary)
		x: geometry.x; y: geometry.y; width: geometry.width; height: geometry.height

		IndicatorRow {
			id: indicatorRow
		}

		Popover {
			id: sessionPopover

			height: sessionList.contentHeight
       		width: Units.dp(250)

			ListView {
				id: sessionList
				model: sessionModel
				currentIndex: sessionModel.lastIndex
				interactive: true
	       		anchors.fill: parent

		    	delegate: ListItem.Standard {
		    		text: name
		    		selected: sessionList.currentIndex == index
		    		onClicked: {
		    			sessionList.currentIndex = index
		    			sessionPopover.close()
		    		}

		    		Icon {
				    	anchors {
				    		verticalCenter: parent.verticalCenter
				    		right: parent.right
				    		rightMargin: Units.dp(16)
				    	}

				    	name: "navigation/check"
				    	visible: selected
				    	color: Theme.primaryColor
				    }
		    	}
			}
		}

		View {
		    id: sessionView

		    anchors {
		        left: parent.left
		        bottom: parent.bottom
		        margins: Units.dp(16)
		    }

		    width: Units.dp(250)
		    height: indicatorRow.height
		    visible: sessionList.count > 0

		    radius: Units.dp(2)
		    elevation: 2

		    Ink {
		    	anchors.fill: parent
		    	onClicked: sessionPopover.open(sessionView, 0, Units.dp(16))
		    }

		    Icon {
		    	anchors {
		    		verticalCenter: parent.verticalCenter
		    		right: parent.right
		    		rightMargin: Units.dp(12)
		    	}

		    	name: "navigation/expand_less"
		    }

		    Label {
		    	anchors {
		    		verticalCenter: parent.verticalCenter
		    		left: parent.left
		    		leftMargin: Units.dp(16)
		    	}

		    	text: sessionList.currentItem.text
		    	style: "subheading"
		    }
		}

		Item {
			id: desktop

		    property alias overlayLayer: desktopOverlayLayer

			function updateTooltip(item, containsMouse) {
		        if (containsMouse) {
		            if (item.tooltip) {
		                tooltip.text = Qt.binding(function() { return item.tooltip })
		                tooltip.open(item, 0, Units.dp(16))
		            }
		        } else if (tooltip.showing) {
		            tooltip.close()
		        }
		    }

		    Tooltip {
		        id: tooltip
		        overlayLayer: "desktopTooltipOverlayLayer"
		    }

			OverlayLayer {
		        id: tooltipOverlayLayer
		        objectName: "desktopTooltipOverlayLayer"
		        z: 100
		        enabled: desktopOverlayLayer.currentOverlay == null
		    }

		    OverlayLayer {
		        id: desktopOverlayLayer
		        z: 99
		        objectName: "desktopOverlayLayer"
		    }
		}

		Row {
			anchors.centerIn: parent

			spacing: Units.dp(32)

			Repeater {
				id: users
				model: userModel

				delegate: UserDelegate {}
			}
		}

		Wave {
			id: background

			color: Palette.colors.blue["500"]
		}

		Label {
			id: label

			anchors.centerIn: parent
			//style: "headline"
			style: "display1"
			text: "Signing in..."
			color: "white"

			opacity: background.opened ? 1 : 0

			Behavior on opacity {
				NumberAnimation {}
			}
		}
	}

	KCoreAddons.KUser {
        id: currentUser
    }

    MprisConnection {
        id: musicPlayer
    }

    Sound {
        id: sound

        property string iconName: sound.muted ? "av/volume_off"
                                  : sound.master <= 33 ? "av/volume_mute"
                                  : sound.master >= 67 ? "av/volume_up"
                                  : "av/volume_down"
    }

	HardwareEngine {
		id: hardware
	}

	property var now: new Date()

	Timer {
		interval: 1000
		repeat: true
		running: true
		onTriggered: now = new Date()
	}
}
