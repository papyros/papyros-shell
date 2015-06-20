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
import QtQuick 2.3
import QtQuick.Layouts 1.0
import Material 0.1
import Material.Extras 0.1

View {
    id: item

    tintColor: ink.containsMouse || selected ? Qt.rgba(0,0,0,0.2) : Qt.rgba(0,0,0,0)

    height: parent.height
    width: height

    property bool selected: indicator.selected
    property string tooltip
    property alias highlightColor: highlight.color
    property alias highlightOpacity: highlight.opacity
    property alias containsMouse: ink.containsMouse

    signal clicked()
    signal rightClicked()

    Ink {
        id: ink

        anchors.fill: parent
        color: Qt.rgba(0,0,0,0.3)
        z: 0

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: {
            if (mouse.button == Qt.RightButton)
                item.rightClicked()
            else
                item.clicked()
        }

        onContainsMouseChanged: desktop.updateTooltip(item, containsMouse)
    }

    Rectangle {
        id: highlight
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        height: Units.dp(2)
        color: Theme.dark.accentColor

        opacity: item.selected ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }
}
