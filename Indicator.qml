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

View {
    id: indicator

    property alias icon: icon.name
    property alias text: label.text
    property string tooltip

    property bool userSensitive
    property bool showing: true

    property bool selected: selectedIndicator == indicator

    signal triggered(var caller)

    onTriggered: {
        if (selected)
            selectedIndicator = null
        else
            selectedIndicator = indicator
    }

    opacity: showing && !(userSensitive && screenLocked) ? 1 : 0

    height: parent.height
    width: opacity > 0 ? text ? label.width + (height - label.height)
                             : height
                       : 0

    backgroundColor: "transparent"
    tintColor: mouseArea.containsMouse ? Qt.rgba(0,0,0,0.2) : "transparent"

    Behavior on opacity {
        NumberAnimation {
            duration: 250
        }
    }

    Behavior on width {
        NumberAnimation {
            duration: 250
        }
    }

    Icon {
        id: icon

        color: "white"
        anchors.centerIn: parent
        size: units.dp(25)
    }

    Label {
        id: label

        color: "white"
        anchors.centerIn: parent
        font.pixelSize: units.dp(19)
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        onClicked: triggered(indicator)
        hoverEnabled: true
    }

    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom

            //bottomMargin: selected ? 0 : -height
        }

        opacity: selected ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }

        height: units.dp(2)
        color: "#FFEB3B"
    }
}
