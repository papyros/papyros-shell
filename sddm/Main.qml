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
import SddmComponents 2.0
import org.kde.kcoreaddons 1.0 as KCoreAddons

MainView {
	anchors.fill: parent

	theme.primaryColor: Palette.colors["blue"]["500"]
	theme.accentColor: Palette.colors["blue"]["500"]

	Repeater {
		model: screenModel

		Background {
			z: -1
			x: geometry.x; y: geometry.y; width: geometry.width; height:geometry.height
			source: config.background
			fillMode: Image.PreserveAspectCrop
			onStatusChanged: {
				if (status === Image.Error && source !== config.defaultBackground) {
	    			source = config.defaultBackground
				}
			}
		}
	}

	property int selectedUser: users.lastIndex
	property int selectedSession: sessionModel.lastIndex

	Item {
		id: primaryScreen

		property var geometry: screenModel.geometry(screenModel.primary)
		x: geometry.x; y: geometry.y; width: geometry.width; height: geometry.height

		Item {
			id: desktop

			anchors.fill: parent

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

		IndicatorRow {
			id: indicatorRow
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

	Connections {
		target: sddm

		onLoginFailed: background.close(primaryScreen.width/2, primaryScreen.height/2)
	}
}
