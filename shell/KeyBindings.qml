/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 *
 * Copyright (C) 2016 Michael Spencer <sonrisesoftware@gmail.com>
 *               2012-2016 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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

import QtQuick 2.5

Item {
    QtObject {
        id: __private

        function switchToWorkspace(number) {
            var i;
            for (i = 0; i < papyrosCompositor.outputs.length; i++)
                papyrosCompositor.outputs[i].screenView.layers.workspaces.select(number);
        }
    }

    /*
     * Special shortcuts
     */

    Shortcut {
        property bool showInformation: false

        context: Qt.ApplicationShortcut
        sequence: "Ctrl+Alt+Meta+S"
        onActivated: {
            showInformation = !showInformation;

            var i;
            for (i = 0; i < papyrosCompositor.outputs.length; i++)
                papyrosCompositor.outputs[i].showInformation = showInformation;
        }
    }

    /*
     * Window Manager
     */

    Shortcut {
        context: Qt.ApplicationShortcut
        sequence: "Meta+Left"
        onActivated: {
            var i;
            for (i = 0; i < papyrosCompositor.outputs.length; i++)
                papyrosCompositor.outputs[i].screenView.layers.workspaces.selectPrevious();
        }
    }

    Shortcut {
        context: Qt.ApplicationShortcut
        sequence: "Meta+Right"
        onActivated: {
            var i;
            for (i = 0; i < papyrosCompositor.outputs.length; i++)
                papyrosCompositor.outputs[i].screenView.layers.workspaces.selectNext();
        }
    }

    /*
    Shortcut {
        context: Qt.ApplicationShortcut
        sequence: wmKeybindings.switchWindows
        onActivated: d.switchWindowsForward()
    }

    Shortcut {
        context: Qt.ApplicationShortcut
        sequence: wmKeybindings.switchWindowsBackward
        onActivated: d.switchWindowsBackward()
    }
    */

    Shortcut {
        context: Qt.ApplicationShortcut
        sequence: wmKeybindings.showDesktop
        onActivated: {
            var i, workspace;
            for (i = 0; i < papyrosCompositor.outputs.length; i++) {
                workspace = papyrosCompositor.outputs[i].screenView.currentWorkspace;
                if (workspace.state === "reveal")
                    workspace.state = "normal";
                else if (workspace.state === "normal")
                    workspace.state = "reveal";
            }
        }
    }

    Shortcut {
        context: Qt.ApplicationShortcut
        sequence: wmKeybindings.presentWindows
        onActivated: {
            var i, workspace;
            for (i = 0; i < papyrosCompositor.outputs.length; i++) {
                workspace = papyrosCompositor.outputs[i].screenView.currentWorkspace;
                if (workspace.state === "present")
                    workspace.state = "normal";
                else if (workspace.state === "normal")
                    workspace.state = "present";
            }
        }
    }

    Shortcut {
        context: Qt.ApplicationShortcut
        sequence: "Super+Space"
        onActivated: papyrosCompositor.defaultOutput.screenView.panel.launcherIndicator.triggered(null)
    }

    /*
     * Session Manager
     */

    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: smKeybindings.abortSession
    //     onActivated: SessionInterface.requestLogOut()
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: smKeybindings.powerOff
    //     onActivated: SessionInterface.requestPowerOff()
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: smKeybindings.lockScreen
    //     onActivated: SessionInterface.lockSession()
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: smKeybindings.activateSession1
    //     onActivated: SessionInterface.activateSession(1)
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: smKeybindings.activateSession2
    //     onActivated: SessionInterface.activateSession(2)
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: smKeybindings.activateSession3
    //     onActivated: SessionInterface.activateSession(3)
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: smKeybindings.activateSession4
    //     onActivated: SessionInterface.activateSession(4)
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: smKeybindings.activateSession5
    //     onActivated: SessionInterface.activateSession(5)
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: smKeybindings.activateSession6
    //     onActivated: SessionInterface.activateSession(6)
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: smKeybindings.activateSession7
    //     onActivated: SessionInterface.activateSession(7)
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: smKeybindings.activateSession8
    //     onActivated: SessionInterface.activateSession(8)
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: smKeybindings.activateSession9
    //     onActivated: SessionInterface.activateSession(9)
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: smKeybindings.activateSession10
    //     onActivated: SessionInterface.activateSession(10)
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: smKeybindings.activateSession11
    //     onActivated: SessionInterface.activateSession(11)
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: smKeybindings.activateSession12
    //     onActivated: SessionInterface.activateSession(12)
    // }

    /*
     * Desktop
     */

    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: desktopKeybindings.screenshot
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: desktopKeybindings.activeWindowScreenshot
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: desktopKeybindings.windowScreenshot
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: desktopKeybindings.areaScreenshot
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: desktopKeybindings.screenshotClip
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: desktopKeybindings.activeWindowScreenshotClip
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: desktopKeybindings.windowScreenshotClip
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: desktopKeybindings.areaScreenshotClip
    // }
    //
    // Shortcut {
    //     context: Qt.ApplicationShortcut
    //     sequence: desktopKeybindings.screencast
    // }
}
