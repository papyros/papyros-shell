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
import QtQuick 2.3
import Material 0.1

import "../components"

/*
* The Panel is the top panel with the status icons on the right and the Quantum icon and active app info on the left.
*/
Rectangle {
    anchors {
        bottom: parent.bottom
        top: parent.top
        left: parent.left
    }

    visible: config.layout == "converge"

    color: Theme.alpha(Theme.accentColor, 0.9)

    Item {
        width: parent.width
        height: parent.height
        anchors.left: parent.right

        clip: true

        View {
            elevation: 2

            anchors.right: parent.left
            width: parent.width
            height: parent.height
        }
    }

    width: units.dp(72)

    Column {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: units.dp(16)
        }

        spacing: units.dp(24)

        Repeater {
            model: ["play_music", "google-inbox"]

            delegate: AppIcon {
                tooltip: "Google Inbox"
                iconSource: Qt.resolvedUrl("../../images/%1.png".arg(modelData))
            }
        }
    }
}
