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
import QtQuick 2.2
import Material 0.1

MainView {
    id: shell

    property Window currentWindow

    property bool overviewMode
    property bool screenLocked

    width: units.dp(1440)
    height: units.dp(900)
    
    Component.onCompleted: theme.accentColor = "#009688"

    onOverviewModeChanged: panel.selectedIndicator = null

    // TODO: Load the wallpaper from user preferences
    Image {
        id: wallpaper

        anchors.fill: parent
        source: Qt.resolvedUrl("../images/quantum_wallpaper.png")
    }

    Item {
        id: content

        opacity: screenLocked ? 0 : 1

        Behavior on opacity {
            NumberAnimation {
                duration: 500
            }
        }

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

        Item {
            id: desktop

            anchors.fill: parent

//            SettingsWindow {

//            }
        }

        Notifications {

        }

        Item {
            id: overlayLayer

            anchors.fill: parent

            NotificationCenter {
                id: notificationCenter
            }
        }
    }
    
    Panel {
        id: panel
    }

    Lockscreen {
        id: lockscreen
    }

    DesktopConfig {
        id: config
    }
}
