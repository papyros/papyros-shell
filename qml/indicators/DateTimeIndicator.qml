/*
 * Quantum Shell - The desktop shell for Quantum OS following Material Design
 * Copyright (C) 2014 Michael Spencer
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

    property var date: new Date()

    text: Qt.formatTime(date)
    tooltip: Qt.formatDate(date, Locale.LongFormat)

    Timer {
        interval: 10 * 100
        repeat: true
        running: true
        onTriggered: date = new Date()
    }

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
