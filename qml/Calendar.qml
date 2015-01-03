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

                IconAction {
                    name: "navigation/chevron_left"

                    anchors.centerIn: parent

                    onTriggered: calendar.showPreviousMonth()
                }
            }

            Label {
                text: styleData.title
                anchors.centerIn: parent
            }

            Item {
                height: parent.height
                width: height

                anchors.right:parent.right
                anchors.verticalCenter: parent.verticalCenter

                IconAction {
                    name: "navigation/chevron_right"

                    anchors.centerIn: parent

                    onTriggered: calendar.showNextMonth()
                }
            }
        }

        dayOfWeekDelegate: Rectangle {
            height: units.dp(30)
            Label {
                text: getDay(styleData.dayOfWeek)
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.light.subTextColor
            }
        }

        dayDelegate: Item {

            Rectangle {
                anchors.centerIn: parent
                width: 0.8 * Math.min(parent.width, parent.height)
                height: width

                color: styleData.today ? Theme.dark.accentColor : selectable && styleData.selected
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

