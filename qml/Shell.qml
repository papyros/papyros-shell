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
import Material.Desktop 0.1
import GSettings 1.0
import "components"
import "desktop"
import "notifications"
import "dashboard"

View {
    id: shell

    signal superPressed()

    signal keyPressed(var event)
    signal keyReleased(var event)

    Component.onCompleted: {
        compositor.init()
    }

    function toggleState(state) {
        if (shell.state == state)
            shell.state = "default"
        else
            shell.state = state
    }

    function toggleDashboard() {
        toggleState("dashboard")
    }

    function toggleHelp() {
        toggleState("help")
    }

    function lockScreen() {
        shell.state = "locked"
    }

    state: "default"

    states: [
        State {
            name: "locked"

            PropertyChanges {
                target: keyFilter
                enabled: false
            }
        },

        State {
            name: "exposed"
        },

        State {
            name: "dashboard"
        },

        State {
            name: "help"
        }
    ]

    onStateChanged: panel.selectedIndicator = null

    backgroundColor: Qt.rgba(0.2, 0.2, 0.2, 1)

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

        NotificationsView {
            id: notifications
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

            HelpOverlay {
                id: helpOverlay
            }
        }
    }

    Panel {
        id: panel
    }

    Dashboard {
        id: dashboard
    }

    Lockscreen {
        id: lockscreen
    }

    // ===== Keyboard Shortcuts =====

    KeyEventFilter {
        id: keyFilter

        enabled: shell.state != "locked"

        Keys.onPressed: shell.keyPressed(event)
        Keys.onReleased: shell.keyReleased(event)
    }

    property bool superOnly: false

    onKeyPressed: {
        if (!keyFilter.enabled) return

        print("Key pressed", event.key)

        if (event.modifiers & Qt.MetaModifier && event.key === Qt.Key_Meta) {
            superOnly = true
            helpTimer.restart()
            return
        }

        superOnly = false
        if (helpTimer.running)
            helpTimer.stop()

        // Use the grid symbol on the Mac keyboard to open the dashboard
        if (event.key == Qt.Key_LaunchD ||
                (event.modifiers & Qt.MetaModifier && event.key === Qt.Key_D)) {
            toggleDashboard()
        }

        // Super + > triggers the help overlay
        if (event.modifiers & Qt.MetaModifier && event.key === Qt.Key_Slash) {
            toggleHelp()
        }

        // Abort session
        if (event.modifiers & (Qt.ControlModifier | Qt.AltModifier) &&
                event.key === Qt.Key_Backspace) {
            event.accepted = true;
            print("Killing session...")
            Qt.quit()

            return;
        }

        // Lock screen
        if (event.modifiers & Qt.MetaModifier && event.key === Qt.Key_L) {
            shell.state = "locked";

            event.accepted = true;
            return;
        }

        // Window switcher
        // if (event.modifiers & Qt.MetaModifier) {
        //     if (event.key === Qt.Key_Tab || event.key === Qt.Key_Backtab) {
        //         if (state != "windowSwitcher" && surfaceModel.count >= 2) {
        //             // Activate only when two or more windows are available
        //             state = "windowSwitcher";
        //             event.accepted = true;
        //             return;
        //         }
        //     }
        // }

        // Present windows
        if (event.modifiers & Qt.MetaModifier && event.key === Qt.Key_E) {
            if (shell.state == "exposed")
                shell.state = "default"
            else
                shell.state = "exposed"

            event.accepted = true;
            return;
        }
    }

    onKeyReleased: {
        if (!keyFilter.enabled) return

        if (superOnly) {
            print("That's super!")

            if (shell.state == "help")
                toggleHelp()
            else
                superPressed()
        }

        superOnly = false
        helpTimer.stop()
    }

    // If the super key is held down for more than
    // 2 seconds, show the help overlay
    Timer {
        id: helpTimer

        interval: 2000
        onTriggered: toggleHelp()
    }

    // ===== Configuration and Settings =====

    DesktopConfig {
        id: config
    }

    GSettings {
        id: wallpaperSetting
        schema.id: "org.gnome.desktop.background"
    }

    SystemNotifications {

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
