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
import Papyros.Desktop 0.1
import Papyros.Indicators 0.1
import QtCompositor 1.0
import GreenIsland 1.0
import org.kde.kcoreaddons 1.0 as KCoreAddons

import "dashboard"
import "desktop"
import "launcher"
import "lockscreen"
import "notifications"

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
        },

        State {
            name: "switcher"
        }
    ]

    backgroundColor: Qt.rgba(0.2, 0.2, 0.2, 1)

    readonly property bool hasErrors: stage.status == Loader.Error
    readonly property string errorMessage: stage.sourceComponent.errorString()

    property alias windowManager: desktop.windowManager

    property string stageName: "classic"
    property list<Indicator> indicators: [
        StorageIndicator {},
        NetworkIndicator {},
        SoundIndicator {},
        BatteryIndicator {},
        ActionCenterIndicator {},
        SystemIndicator {}
    ]
    property list<Action>keybindings: [
        Action {
            name: "Kill session"
            keybinding: "Ctrl+Alt+Backspace"
            onTriggered: Compositor.abortSession();
        },

        Action {
            id: lockAction
            name: "Lock your " + Device.name
            keybinding: "Alt+L"
            onTriggered: lockScreen();
        }
    ]

    property alias screenInfo: __screenInfo

    signal superPressed()

    signal keyPressed(var event)
    signal keyReleased(var event)

    onStateChanged: {
        powerDialog.close()
    }

    function toggleState(state) {
        if (shell.state == state)
        shell.state = "default"
        else
        shell.state = state
    }

    function lockScreen() {
        shell.state = "locked"
    }

    function showPowerDialog() {
        print("Showing power dialog!")
        if (SessionManager.canSuspend || SessionManager.canHibernate ||
                SessionManager.canPowerOff) {
            powerDialog.open()
        }
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

        NotificationsView {

        }

        onXChanged: updateOutputGeometry()
        onYChanged: updateOutputGeometry()
        onWidthChanged: updateOutputGeometry()
        onHeightChanged: updateOutputGeometry()

        function updateOutputGeometry() {
            _greenisland_output.availableGeometry = Qt.rect(x,y,width,height)
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

    PowerDialog {
        id: powerDialog
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

        print("Key pressed", event.key, event.text)

        if (event.modifiers & Qt.MetaModifier && event.key === Qt.Key_Meta) {
            superOnly = true
            helpTimer.restart()
            return
        }

        superOnly = false

        if (event.key == Qt.Key_PowerOff || event.key == Qt.Key_PowerDown ||
                event.key == Qt.Key_Suspend || event.key == Qt.Key_Hibernate) {
            showPowerDialog()
            return
        }

        // Window switcher
        if (event.modifiers === Qt.ControlModifier) {
            if (state === "switcher") {
                if (event.key === Qt.Key_Tab) {
                    desktop.windowSwitcher.next()
                    event.accepted = true;
                    return
                } else if (event.key === Qt.Key_Backtab) {
                    desktop.windowSwitcher.prev()
                    event.accepted = true;
                    return
                } else if (event.key === Qt.Key_QuoteLeft) {
                    desktop.windowSwitcher.nextWindow()
                    event.accepted = true;
                    return
                } else if (event.key === Qt.Key_AsciiTilde) {
                    desktop.windowSwitcher.prevWindow()
                    event.accepted = true;
                    return
                }
            } else if (event.key === Qt.Key_Tab) {
                if (desktop.windowSwitcher.enabled) {
                    if (appNextTimer.running) {
                        desktop.windowSwitcher.show()
                        desktop.windowSwitcher.next()
                    } else {
                        appNextTimer.start()
                    }
                    event.accepted = true;
                    return;
                }
            } else if (event.key === Qt.Key_Backtab) {
                if (desktop.windowSwitcher.enabled) {
                    if (appPreviousTimer.running) {
                        desktop.windowSwitcher.show()
                        desktop.windowSwitcher.prev()
                    } else {
                        appPreviousTimer.start()
                    }
                    event.accepted = true;
                    return;
                }
            } else if (event.key === Qt.Key_QuoteLeft) {
                if (desktop.windowSwitcher.enabled) {
                    if (windowNextTimer.running) {
                        desktop.windowSwitcher.show()
                        desktop.windowSwitcher.nextWindow()
                    } else {
                        windowNextTimer.start()
                    }
                    event.accepted = true;
                    return;
                }
            } else if (event.key === Qt.Key_AsciiTilde) {
                if (desktop.windowSwitcher.enabled) {
                    if (windowPreviousTimer.running) {
                        desktop.windowSwitcher.show()
                        desktop.windowSwitcher.prevWindow()
                    } else {
                        windowPreviousTimer.start()
                    }
                    event.accepted = true;
                    return;
                }
            }
        }

        if (event.key == Qt.Key_Down && state == "switcher") {
            desktop.windowSwitcher.showWindowsView()

            event.accepted = true;
            return;
        }

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
            return
        }
    }

    onKeyReleased: {
        if (!keyFilter.enabled) return

        if (superOnly) {
            superPressed()
        }

        superOnly = false

        if (event.key == Qt.Key_Control) {
            print("Releasing control!", event.key)
            if (state == "switcher") {
                desktop.windowSwitcher.dismiss()
            } else if (appNextTimer.running) {
                appNextTimer.stop()
                desktop.switchNext()
            } else if (appPreviousTimer.running) {
                appPreviousTimer.stop()
                desktop.switchPrev()
            } else if (windowNextTimer.running) {
                windowNextTimer.stop()
                desktop.switchNextWindow()
            } else if (windowPreviousTimer.running) {
                windowPreviousTimer.stop()
                desktop.switchPrevWindow()
            }
        }
    }

    Timer {
        id: appNextTimer
        interval: 100
        onTriggered: {
            desktop.windowSwitcher.show()
            desktop.windowSwitcher.next()
        }
    }

    Timer {
        id: appPreviousTimer
        interval: 100
        onTriggered: {
            desktop.windowSwitcher.show()
            desktop.windowSwitcher.prev()
        }
    }

    Timer {
        id: windowNextTimer
        interval: 100
        onTriggered: {
            desktop.windowSwitcher.show()
            desktop.windowSwitcher.nextWindow()
        }
    }

    Timer {
        id: windowPreviousTimer
        interval: 100
        onTriggered: {
            desktop.windowSwitcher.show()
            desktop.windowSwitcher.prevWindow()
        }
    }

    // ===== Configuration and Settings =====

    Connections {
        target: ShellSettings.desktop

        Component.onCompleted: {
            Theme.accentColor = Palette.colors[ShellSettings.desktop.accentColor]['500']
            DesktopFiles.iconTheme = ShellSettings.desktop.iconTheme
        }

        onValueChanged: {
            if (key == "accentColor") {
                Theme.accentColor = Palette.colors[ShellSettings.desktop.accentColor]['500']
            } else if (key == "iconTheme") {
                DesktopFiles.iconTheme = ShellSettings.desktop.iconTheme
            }
        }
    }

    QtObject {
        id: __screenInfo

        readonly property string name: _greenisland_output.name
        readonly property int number: _greenisland_output.number
        readonly property bool primary: _greenisland_output.primary
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
