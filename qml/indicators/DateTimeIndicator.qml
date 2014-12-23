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
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1
import Material 0.1
import Material.ListItems 0.1 as ListItem
import ".."

Indicator {
    id: indicator

    property var date: new Date()

    text: Qt.formatTime(date)
    tooltip: "Date & Time"

    Timer {
        interval: 10 * 100
        repeat: true
        running: true
        onTriggered: date = new Date()
    }

    dropdown: DropDown {
        implicitHeight: units.dp(300)
        implicitWidth: 500
        View {

            anchors.fill: parent


            Calendar {
                x : 10
                y:10
                id:calendar
                width:units.dp(250)
                height: parent.height - units.dp(20)

                style: CalendarStyle {
                    gridVisible: false

                    navigationBar: RowLayout {
                        height: units.dp(40)

                        Icon{
                            name: "navigation/chevron_left"
                            anchors.left:parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            height:parent.height

                            MouseArea{anchors.fill:parent;onClicked: calendar.showPreviousMonth();}
                        }

                        Label {
                            text: styleData.title
                            anchors.centerIn: parent
                        }

                        Icon{
                            name: "navigation/chevron_right"
                            anchors.right:parent.right
                            anchors.verticalCenter: parent.verticalCenter

                            height:parent.height
                            MouseArea{anchors.fill:parent;onClicked: calendar.showNextMonth();}
                        }
                    }

                    dayOfWeekDelegate: Rectangle {
                        height: units.dp(30)
                        Label {
                            text: getDay(styleData.dayOfWeek)
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    dayDelegate: Rectangle {
                        gradient: Gradient {
                            GradientStop {
                                position: 0.00
                                id: gr
                                color: styleData.selected ? set() : (styleData.visibleMonth
                                                                     && styleData.valid ? "#444" : "#666")
                            }
                        }

                        function set() {
                            label.text = Qt.formatDateTime(styleData.date,
                                                           "ddd MMMM d, yyyy")
                            return "#111"
                        }

                        Label {
                            text: styleData.date.getDate()
                            anchors.centerIn: parent
                            color: styleData.valid ? "white" : "grey"
                        }
                    }
                }
            }

            Column {
                anchors.left: calendar.right
                width: label.implicitWidth
                anchors.right: parent.right
                View {
                    id: view
                    height: label.height + units.dp(32)
                    width: parent.width

                    Label {
                        id: label
                        anchors {
                            left: parent.left
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            margins: units.dp(16)
                        }

                        text: Date().toString()
                        style: "title"
                        font.pixelSize: units.dp(25)
                    }
                }

                ListItem.Header {
                    text: "Upcoming events"
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
