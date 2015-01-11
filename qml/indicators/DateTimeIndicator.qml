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
import "../components"

Indicator {
    id: indicator

    text: Qt.formatTime(now)
    tooltip: Qt.formatDate(now, Locale.LongFormat)

    dropdown: DropDown {
        height: units.dp(300)
        width: units.dp(300)

        Calendar {
            id: calendar
            anchors.fill: parent

            frameVisible: false
        }
    }

    function getDay(day) {

        var days = {
            0: "Sun",
            1: "Mon",
            2: "Tue",
            3: "Wed",
            4: "Thu",
            5: "Fri",
            6: "Sat"
        }

        return days[day]
    }
}
