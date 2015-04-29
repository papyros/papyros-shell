/*
 * Quantum Shell - The desktop shell for Quantum OS following Material Design
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
import QtQuick 2.0
import Material 0.1
import Material.Desktop 0.1

Item {
    anchors.fill: parent

    NotificationServer {
        id: notifyServer
    }

    ListView {
        id: listView

        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            margins: units.dp(16)
        }

        opacity: panel.selectedIndicator ? 0 : 1

        Behavior on opacity {
          NumberAnimation { duration: 200 }
        }

        width: units.dp(280)

        verticalLayoutDirection: config.layout == "classic"
                                 ? ListView.BottomToTop : ListView.TopToBottom 
        orientation: Qt.Vertical
        interactive: false

        model: notifyView.notifications

        spacing: units.dp(16)

        delegate: NotificationCard {
            notification: model
        }

        add: Transition {
            SequentialAnimation {
                // Make sure the card is completely off-screen at the start of the animation
                PropertyAction { properties: "y"; value: units.dp(20) }

                ParallelAnimation {
                    NumberAnimation { property: "opacity"; from: 0; duration: animationDuration }
                    NumberAnimation { properties: "y"; duration: animationDuration }
                }
            }
        }

        addDisplaced: Transition {
            NumberAnimation { properties: "y"; duration: animationDuration }
        }

        remove: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; to: 0; duration: animationDuration }
                NumberAnimation { properties: "x"; to: listView.width; duration: animationDuration }
            }
        }

        removeDisplaced: Transition {
            SequentialAnimation {
                PauseAnimation { duration: animationDuration }

                NumberAnimation { properties: "y"; duration: animationDuration }
            }
        }
    }

    property int animationDuration: 300
}
