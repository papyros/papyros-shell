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
import org.kde.kcoreaddons 1.0 as KCoreAddons

import "desktop"
import "lockscreen"
import "notifications"

View {
    id: shell

    state: "default"

    states: [
        State {
            name: "locked"

            PropertyChanges {
                target: keyboardListener
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
        // FIXME: Uncomment after fixing the sound code (see comment above sound object)
        // SoundIndicator {},
        BatteryIndicator {},
        ActionCenterIndicator {},
        SystemIndicator {}
    ]
    property list<Action>keybindings: [
        Action {
            name: "Kill session"
            shortcut: "Ctrl+Alt+Backspace"
            onTriggered: Compositor.abortSession();
        },

        Action {
            id: lockAction
            name: "Lock your " + Device.name
            shortcut: "Alt+L"
            onTriggered: lockScreen();
        }
    ]

    property alias screenInfo: __screenInfo

    signal superPressed()

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

    KeyboardListener {
        id: keyboardListener
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

    // FIXME: For some reason, uncommenting the Sound object causes the shell to lock up
    // when starting from a VT or DM
    // Sound {
    //     id: sound
    //
    //     property string iconName: sound.muted || sound.master == 0
    //                               ? "av/volume_off"
    //                               : sound.master <= 33 ? "av/volume_mute"
    //                               : sound.master >= 67 ? "av/volume_up"
    //                               : "av/volume_down"
    // }

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
