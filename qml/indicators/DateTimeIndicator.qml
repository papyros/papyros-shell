import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
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
        SplitView {
            anchors.fill: parent
            Calendar {
                width:units.dp(250)

                style: CalendarStyle {
                    gridVisible: false

                    navigationBar: Rectangle {
                        height: units.dp(40)
                        Label {
                            text: styleData.title
                            anchors.centerIn: parent
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
                width: parent.width

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

                        text: "Saturday,\nNovember 8th"
                        //style: "title"
                        font.pixelSize: units.dp(30)
                    }
                }

                ListItem.Header {
                    text: "Upcoming events"
                }
            }
        }
    }

    function getDay(day) {
        console.log(day)
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
