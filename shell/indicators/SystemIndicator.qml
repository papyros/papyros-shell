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
import QtQuick 2.0
import Material 0.1
import Material.ListItems 0.1 as ListItem
import ".."

Indicator {
    id: indicator

    iconSource: shell.state == "locked"
            ? "icon://action/power_settings_new" : currentUser.faceIconUrl != ""
                          ? currentUser.faceIconUrl : "icon://action/account_circle"

    // TODO: Handle guest users here
    tooltip: currentUser.fullName !== "" ? currentUser.fullName : currentUser.loginName

    circleClipIcon: currentUser.faceIconUrl != ""

    view: Column {
        ListItem.Standard {
            id: lockItem

            iconName: "action/lock"
            text: "Lock"
            valueText: lockAction.keybinding
            visible: shell.state !== "locked"
            onClicked: lockAction.triggered(lockItem)
        }

        ListItem.Standard {
            iconName: "action/power_settings_new"
            text: "Power off"
            onClicked: SessionManager.powerOff()
        }

        ListItem.Standard {
            iconSource: Qt.resolvedUrl("../images/reload.svg")
            text: "Reboot"
            onClicked: SessionManager.reboot()
        }
    }
}
