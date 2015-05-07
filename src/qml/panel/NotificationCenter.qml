/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 * Copyright (C) 2015 Michael Spencer
 *               2015 Bogdan Cuza
 *               2015 Ricardo Vieira
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
import Material.Extras 0.1

View {
    fullHeight: true

    elevation: 2
    backgroundColor: "#fafafa"

    property bool showing: false

    anchors {
        right: parent.right
        top: parent.top
        bottom: parent.bottom

        rightMargin: showing ? 0 : -width - units.dp(5)

        Behavior on rightMargin {
            NumberAnimation { duration: 200 }
        }
    }

    width: units.dp(275)

    property var widgets: ["Music"]

    View {
        id: view
        height: label.height + units.dp(16)
        width: parent.width
        backgroundColor: "#fafafa"
        z: 10

        Label {
            id: label
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                leftMargin: units.dp(16)
                rightMargin: units.dp(16)
            }

            text:  Qt.formatDateTime(now, "dddd',<br>'MMMM d'<sup>%1</sup>'"
                    .arg(Utils.nth(now.getDate())))

            style: "title"
            font.pixelSize: units.dp(30)
            textFormat: Text.RichText
        }
    }

    Flickable {
        anchors {
            top: view.bottom
            left: parent.left
            right: parent.right
            bottom: silentMode.bottom
            topMargin: units.dp(16)
        }
        z: 5
        contentHeight: widgetCol.height
        interactive: contentHeight > height
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: widgetCol

            width: parent.width

            Repeater {
                model: widgets
                delegate: Loader {
                    source: Qt.resolvedUrl("../widgets/%1.qml".arg(modelData))

                    anchors {
                        left: parent.left
                        right: parent.right
                        margins: units.dp(16)
                    }
                }
            }
        }
    }

    Rectangle {
        id: silentMode

        anchors.bottom: parent.bottom
        height: units.dp(46)
        width: parent.width
        color: "#fafafa"
        z: 10

        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: units.dp(16)
            }

            height: units.dp(30)

            Label {
                anchors.verticalCenter: parent.verticalCenter

                text: "Silent mode"
            }

            Switch {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right

                checked: config.silentMode
                onCheckedChanged: config.silentMode = checked
            }
        }
    }
}
