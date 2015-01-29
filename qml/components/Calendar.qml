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
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import Material 0.1
import QtQuick.Controls.Private 1.0

Calendar {
    id:calendar

    property bool selectable

    style: CalendarStyle {
        gridVisible: false

        background: Rectangle {
            color: "transparent"
            implicitWidth: Math.max(250, Math.round(TextSingleton.implicitHeight * 14))
            implicitHeight: Math.max(250, Math.round(TextSingleton.implicitHeight * 14))
        }


        navigationBar: RowLayout {
            height: units.dp(40)

            Item {
                anchors.left:parent.left
                anchors.verticalCenter: parent.verticalCenter

                height: parent.height
                width: height

                IconButton {
                    name: "navigation/chevron_left"

                    anchors.centerIn: parent

                    onTriggered: calendar.showPreviousMonth()
                }
                visible: selectable
            }

            Label {
                text: styleData.title
                style: "subheading"
                font.bold: true
                anchors.centerIn: parent
            }

            Item {
                height: parent.height
                width: height

                anchors.right:parent.right
                anchors.verticalCenter: parent.verticalCenter

                IconButton {
                    name: "navigation/chevron_right"

                    anchors.centerIn: parent

                    onTriggered: calendar.showNextMonth()
                }
                visible: selectable
            }
        }

        dayOfWeekDelegate: Rectangle {
            height: units.dp(30)
            Label {
                text: getDay(styleData.dayOfWeek).substring(0, 1)
                anchors.centerIn: parent
                color: Theme.light.subTextColor
            }
        }

        dayDelegate: Item {

            Rectangle {
                anchors.centerIn: parent
                width: 1 * Math.min(parent.width, parent.height)
                height: width

                color: styleData.today
                       ? Theme.dark.accentColor : selectable && styleData.selected
                                                  ? "blue" : "transparent"
                radius: height/2
            }

            Label {
                text: styleData.date.getDate()
                anchors.centerIn: parent
                color: styleData.today || (selectable && styleData.selected)
                       ? "white" : styleData.visibleMonth && styleData.valid
                                   ? Theme.light.textColor : Theme.light.hintColor
            }
        }
    }
}
