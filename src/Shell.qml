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
import QtCompositor 1.0
import GreenIsland 1.0

import "backend"
import "components"
import "dashboard"
import "desktop"
import "launcher"
import "lockscreen"
import "notifications"
import "indicators"

View {
    id: shell

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
        }
    ]

    backgroundColor: Qt.rgba(0.2, 0.2, 0.2, 1)

    readonly property bool hasErrors: stage.status == Loader.Error
    readonly property string errorMessage: stage.sourceComponent.errorString()

    property string stageName: "desktop"
    property list<Indicator> indicators: [
        DateTimeIndicator {},
        NotificationsIndicator {},
        OperationsIndicator {},
        ActionCenterIndicator {},
        SoundIndicator {},
        BatteryIndicator {},
        SystemIndicator {}
    ]
    property list<Action>keybindings: [
        Action {
            name: "Kill session"
            keybinding: "Ctrl+Alt+Backspace"
            onTriggered: compositor.abortSession();
        },

        Action {
            name: "Lock your " + Device.name
            keybinding: "Super+L"
            onTriggered: lockScreen();
        }
    ]

    property alias config: __config

    property alias screenInfo: __screenInfo

    signal superPressed()

    signal keyPressed(var event)
    signal keyReleased(var event)

    function toggleState(state) {
        if (shell.state == state)
        shell.state = "default"
        else
        shell.state = state
    }

    function lockScreen() {
        shell.state = "locked"
    }

    Desktop {
        id: desktop
        clip: true
    }

    Item {
        id: overlayLayer

        anchors {
            fill: parent
            leftMargin: stage.item.leftMargin
            rightMargin: stage.item.rightMargin
            topMargin: stage.item.topMargin
            bottomMargin: stage.item.bottomMargin
        }
    }

    Loader {
        id: stage

        anchors.fill: parent

        Component.onCompleted: {
            var uppercaseName = stageName.substring(0, 1).toUpperCase() +
                    stageName.substring(1)

            var source =  Qt.resolvedUrl("stages/" + stageName + "/" +
                    uppercaseName + "Stage.qml")

            var component = Qt.createComponent(source)
            stage.sourceComponent = component
        }
    }

    Lockscreen {
        id: lockscreen
    }

    // ===== Compositor connections =====

    Timer {
        id: idleTimer
        //interval: compositor.idleInterval
        onIntervalChanged: {
            if (running)
            restart();
        }
    }

    // Code taken from Hawii desktop shell
    Connections {
        target: compositor
        onIdleInhibitResetRequested: compositor.idleInhibit = 0
        onIdleTimerStartRequested: idleTimer.running = true
        onIdleTimerStopRequested: idleTimer.running = false
        onLockedChanged: {
            if (compositor.locked)
                lockScreen()
            else
                shell.state = "default";
        }

        // TODO: Handle session stuff.
        // onIdle: {
        //     // Set idle hint
        //     session.idle = true;
        // }
        // onWake: {
        //     // Unset idle hint
        //     session.idle = false;
        // }

        // TODO: What does this do, and why?
        // onFadeIn: {
        //     // Bring user layer up
        //     compositorRoot.state = "session";
        // }
        // onFadeOut: {
        //     // Fade the desktop out
        //     compositorRoot.state = "splash";
        // }
        onReady: {
            // Start idle timer
            idleTimer.running = true
        }
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

        for (var i = 0; i < keybindings.length; i++) {
            var action = keybindings[i]

            var keybinding = action.keybinding.split("+")
            var keycode = -1
            var modifiers = 0
            var text = ''

            for (var j = 0; j < keybinding.length; j++) {
                var key = keybinding[j]

                if (key == 'Ctrl')
                    modifiers |= Qt.ControlModifier
                else if (key == 'Alt')
                    modifiers |= Qt.AltModifier
                else if (key == 'Super')
                    modifiers |= Qt.MetaModifier
                else if (key == 'Backspace')
                    keycode = Qt.Key_Backspace
                else
                    text = key.toLowerCase()
            }

            if (modifiers != -1 && event.modifiers != modifiers)
                continue
            if (event != -1 && text == '' && event.key != keycode)
                continue
            if (text != '' && event.text != text)
                continue

            print("Action triggered: " + action.name)
            event.accepted = true;
            action.triggered(shell)
        }
    }

    onKeyReleased: {
        if (!keyFilter.enabled) return

        if (superOnly) {
            superPressed()
        }

        superOnly = false
    }

    // ===== Configuration and Settings =====

    DesktopConfig {
        id: __config

        onAccentColorChanged: {
            Theme.accentColor = Palette.colors[config.accentColor]['500']
        }
    }

    QtObject {
        id: __screenInfo

        readonly property string name: _greenisland_output.name
        readonly property int number: _greenisland_output.number
        readonly property bool primary: _greenisland_output.primary
    }

    GSettings {
        id: wallpaperSetting
        schema.id: "org.gnome.desktop.background"
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
