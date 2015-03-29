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
import QtQuick 2.0
import QtOrganizer 5.0
import QtQuick.Layouts 1.1
import Material 0.1
import Material.ListItems 0.1 as ListItem
import "../components"

Indicator {
    id: indicator

    text: Qt.formatTime(now)
    tooltip: Qt.formatDate(now, Locale.LongFormat)

    view: Item {
        id: dropdown

        implicitWidth: config.showEvents ? units.dp(600) : units.dp(300)
        implicitHeight: titleItem.height + subItem.height + calendar.height + units.dp(32)

        property bool showEvents: width > units.dp(300)

        Item {
            id: titleItem

            width: parent.width
            height: dayLabel.height + units.dp(16)
            clip: true

            Rectangle {
                width: parent.width
                height: dropdown.height
                radius: units.dp(2)

                color: Palette.colors[config.accentColor]['700']
            }

            Label {
                id: dayLabel
                anchors.centerIn: parent
                text: Qt.formatDate(now, "dddd")
                color: Theme.dark.textColor
            }
        }

        Rectangle {
            id: subItem
            anchors.top: titleItem.bottom

            width: parent.width
            height: column.height + units.dp(32)
            color: Palette.colors[config.accentColor]['500']

            Column {
                id: column
                anchors.centerIn: parent

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Qt.formatDate(now, "MMM").toUpperCase()
                    style: "title"
                    color: Theme.dark.textColor
                    font.pixelSize: units.dp(27)
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Qt.formatDate(now, "dd")
                    style: "display3"
                    color: Theme.dark.textColor
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Qt.formatDate(now, "yyyy")
                    style: "title"
                    color: Theme.dark.subTextColor
                    font.pixelSize: units.dp(27)
                }
            }
        }

        Item {
            anchors {
                top: subItem.bottom
                left: parent.left
                right: parent.right
                margins: units.dp(16)
            }
            height: calendar.height

            Calendar {
                id: calendar
                anchors {
                    top: parent.top
                    left: parent.left
                    right: dropdown.showEvents ? parent.horizontalCenter : parent.right
                    rightMargin: dropdown.showEvents ? units.dp(16) : 0
                }

                frameVisible: false
            }

            Rectangle {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                color: Theme.light.dividerColor
                width: units.dp(1)
                visible: dropdown.showEvents
            }

            Item {
                visible: dropdown.showEvents

                anchors {
                    top: parent.top
                    right: parent.right
                    left: parent.horizontalCenter
                    leftMargin: units.dp(16)
                }

                RowLayout {
                    anchors {
                        right: parent.right
                        bottom: parent.bottom
                    }

                    spacing: units.dp(16)

                    IconButton {
                        name: "content/add"
                    }

                    IconButton {
                        name: "action/settings"
                    }
                }

                height: parent.height

                Label {
                    anchors.centerIn: parent
                    text: "No events today! " + organizer.availableManagers
                    color: Theme.light.hintColor
                    style: "subheading"
                }

                ListView {
                    anchors.fill: parent

                    model: organizer
                    delegate: ListItem.Subtitled {
                        text: model.item.displayLabel
                        subText: Qt.formatTime(model.item.startDateTime) + " - " +
                                 Qt.formatTime(model.item.endDateTime)
                    }
                }

                OrganizerModel {
                    id: organizer
                    startPeriod: new Date()
                    endPeriod: new Date()
                    manager: "eds"
                }
            }
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
