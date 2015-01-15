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
import QtQuick 2.2
import QtQuick.Window 2.0
import Material 0.1
import GSettings 1.0
import "components"
import "desktop"

View {
    id: shell

    elevation: 10
    backgroundColor: Qt.rgba(0.2, 0.2, 0.2, 1)

    states: [
        State {
            name: "locked"
        },

        State {
            name: "exposed"
        }
    ]

    onStateChanged: panel.selectedIndicator = null

    Desktop {
        id: desktop
        clip: true
    }

    Item {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom

            topMargin: config.layout == "classic" ? 0 : panel.height
            bottomMargin: config.layout == "classic" ? panel.height : 0

            Behavior on topMargin {
                NumberAnimation { duration: 200 }
            }

            Behavior on bottomMargin {
                NumberAnimation { duration: 200 }
            }
        }

        Notifications {

        }

        Item {
            id: overlayLayer

            anchors.fill: parent

            NotificationCenter {
                id: notificationCenter
            }

            SystemCenter {
                id: systemCenter
            }
        }
    }

    Panel {
        id: panel
    }

    Lockscreen {
        id: lockscreen
    }

    // ===== Configuration and Settings =====

    DesktopConfig {
        id: config
    }

    GSettings {
        id: wallpaperSetting
        schema.id: "org.gnome.desktop.background"
    }

    UPower {
        id: upower
    }

    property var now: new Date()

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: now = new Date()
    }
}
