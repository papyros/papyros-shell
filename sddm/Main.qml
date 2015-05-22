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
import Material.Extras 0.1
import Papyros.Desktop 0.1

MainView {
	anchors.fill: parent

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

		property var geometry: screenModel.geometry(screenModel.primary)
		x: geometry.x; y: geometry.y; width: geometry.width; height: geometry.height

		IndicatorRow {}

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

	UPower {
		id: upower
	}

	Sound {
		id: sound

		property string iconName: sound.muted ? "av/volume_off"
		: sound.master <= 33 ? "av/volume_mute"
		: sound.master >= 67 ? "av/volume_up"
		: "av/volume_down"
	}

	property var now: new Date()

	Timer {
		interval: 1000
		repeat: true
		running: true
		onTriggered: now = new Date()
	}
}
