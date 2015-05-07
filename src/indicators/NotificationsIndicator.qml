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
import Material.Desktop 0.1
import Material.Extras 0.1
import "../components"

Indicator {
    id: indicator

    iconName: config.silentMode ? "social/notifications_off"
                                : hasNotifications ? "social/notifications"
                                                   : "social/notifications_none"

    tooltip: config.silentMode ? "Notifications silenced"
                               : hasNotifications ? "%1 notifications".arg(notificationsCount)
                                                  : "No notifications"

    badge: notificationsCount

    property bool hasNotifications: badge > 0
    property int notificationsCount: 4

    onSelectedChanged: {
        notificationCenter.showing = selected
    }
}
