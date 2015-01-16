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

    function add(notification) {

        var newId = notification.hasOwnProperty("id")
                ? notification.id : notification.notificationId

        for (var i = 0; i < notifications.count; i++) {
            var note = notifications.get(i)

            var noteId = note.id ? note.id : note.notificationId

            if (note.timer)
                note.timer.stop()

            if (noteId == newId) {
                notifications.set(i, notification)
                return
            }
        }

        // The notification didn't already exist, so add it instead
        notifications.insert(0, notification)
    }

    function remove(notification) {

        var newId = notification.hasOwnProperty("id")
                ? notification.id : notification.notificationId

        for (var i = 0; i < notifications.count; i++) {
            var note = notifications.get(i)

            var noteId = note.id ? note.id : note.notificationId

            if (noteId == newId) {
                notifications.remove(i)
                return
            }
        }
    }

    NotificationServer {
        id: notifyServer

        onNotificationAdded: {
            notifications.insert(0, notification)
        }

        onNotificationUpdated: {
            for (var i = 0; i < notifications.count; i++) {
                var note = notifications.get(i)

                if (note.id == id) {
                    notifications.set(i, notification)
                    return
                }
            }

            // The notification didn't already exist, so add it instead
            notifications.insert(0, notification)
        }

        onNotificationRemoved: {

            for (var i = 0; i < notifications.count; i++) {
                var note = notifications.get(i)

                var noteId = note.id ? note.id : note.notificationId

                print("ID", noteId, id)

                if (noteId == id) {
                    notifications.remove(i)
                    return
                }
            }
        }
    }

    ListModel {
        id: notifications
    }

    ListView {
        id: listView

        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            margins: units.dp(16)
        }

        width: units.dp(280)

        verticalLayoutDirection: ListView.BottomToTop
        orientation: Qt.Vertical
        interactive: false

        model: notifications

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
