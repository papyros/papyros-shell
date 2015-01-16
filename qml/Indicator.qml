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
import "components"

View {
    id: indicator

    default property alias contents: mouseArea.data

    property alias icon: icon.name
    property alias text: label.text
    property string tooltip

    property bool showing: true

    property alias label: label
    property alias iconSize: icon.size
    property color highlightColor: Theme.dark.accentColor

    property bool selected: selectedIndicator == indicator

    property DropDown dropdown

    property bool dimIcon

    signal triggered(var caller)

    onSelectedChanged: {
        if (tooltip.showing)
            tooltip.close()

        if (dropdown) {
            if (selected) {
                dropdown.open(indicator)
            } else {
                dropdown.close()
            }
        }
    }

    onTriggered: {
        if (selected) {
            selectedIndicator = null
        } else {
            selectedIndicator = indicator
        }
    }

    opacity: showing ? 1 : 0

    height: parent.height
    width: opacity > 0 ? text ? label.width + (units.dp(40) - label.height)
                             : units.dp(40) : 0

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
        size: config.layout == "classic" ? units.dp(20) : units.dp(16)

        opacity: dimIcon ? 0.6 : 1

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    Label {
        id: label

        color: "white"
        anchors.centerIn: parent
        font.pixelSize: units.dp(14)
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        onClicked: triggered(indicator)
        hoverEnabled: true

        onContainsMouseChanged: {
            if (!tooltip.text || selectedIndicator != null) return

            if (containsMouse) {
                if (!tooltip.showing)
                    tooltip.open(indicator)
            } else {
                if (tooltip.showing)
                    tooltip.close()
            }
        }
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
        color: highlightColor
    }

    Tooltip {
        id: tooltip

        text: indicator.tooltip

        onTextChanged: {
            if (!tooltip.text && tooltip.showing) {
                tooltip.close()
                return
            }

            if (mouseArea.containsMouse && tooltip.text && !tooltip.showing && !selected) {
                tooltip.open(indicator)
            }
        }
    }
}
