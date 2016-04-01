/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
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

import QtQuick 2.4
import Material 0.1
import Papyros.Desktop 0.1

KeyEventFilter {
    id: keyFilter

    property bool superOnly: false

    Keys.onPressed: {
        if (!keyFilter.enabled) return

        print("Key pressed", event.key, event.text)

        if (event.modifiers & Qt.MetaModifier && event.key === Qt.Key_Meta) {
            superOnly = true
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
            if (shell.state === "switcher") {
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

        if (event.key == Qt.Key_Down && shell.state == "switcher") {
            desktop.windowSwitcher.showWindowsView()

            event.accepted = true;
            return;
        }

        for (var i = 0; i < keybindings.length; i++) {
            var action = keybindings[i]

            var keybinding = action.shortcut.split("+")
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

    Keys.onReleased: {
        if (!keyFilter.enabled) return

        if (superOnly) {
            superPressed()
            event.accepted = true
        }

        superOnly = false

        if (event.key == Qt.Key_Control) {
            print("Releasing control!", event.key, desktop)
            if (shell.state == "switcher") {
                desktop.windowSwitcher.dismiss()
                event.accepted = true
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
}
