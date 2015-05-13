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
import "../indicators"
import "."

View {
    id: indicatorView

    tintColor: ink.containsMouse || selected ? Qt.rgba(0,0,0,0.2) : Qt.rgba(0,0,0,0)

    height: parent.height
    width: smallMode ? indicator.text ? label.width + (height - label.height) : height
                     : indicator.text ? label.width + (Units.dp(30) - label.height) 
                                      : indicator.circleClipIcon ? Units.dp(30 * 1.2) 
                                                                 : Units.dp(30)

    visible: !indicator.hidden && indicator.visible

    property bool smallMode: height < Units.dp(40)
    property Indicator indicator

    property int iconSize: height > Units.dp(40) ? height * 0.36 : height * 0.45

    onIndicatorChanged: indicator.selected = Qt.binding(function() {
        return desktop.overlayLayer.currentOverlay == dropdown
    })

    readonly property bool selected: indicator.selected

    Ink {
        id: ink

        anchors.fill: parent
        color: Qt.rgba(0,0,0,0.3)
        z: 0

        onClicked: {
            if (selected)
                dropdown.close()
            else if (indicator.view)
                dropdown.open(indicatorView, 0, Units.dp(16))
        }

        onContainsMouseChanged: desktop.updateTooltip(indicatorView, containsMouse)
    }

    Icon {
        anchors.centerIn: parent
        size: iconSize
        source: indicator.iconSource
        color: indicator.color
        visible: !indicator.circleClipIcon
    }

    CircleImage {
        id: circleImage
        anchors.centerIn: parent
        width: iconSize * 1.2
        height: width
        source: visible ? indicator.iconSource : ""
        visible: indicator.circleClipIcon
    }

    Label {
        id: label
        anchors.centerIn: parent
        text: indicator.text
        color: Theme.dark.textColor
        font.pixelSize: Units.dp(14)
    }

    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        height: Units.dp(2)
        color: Theme.dark.accentColor

        opacity: indicator.selected ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    Rectangle {
        anchors {
            left: parent.horizontalCenter
            top: parent.verticalCenter
            margins: Units.dp(1)
        }

        color: Palette.colors.red["500"]
        border.color: Palette.colors.red["700"]
        radius: width//Units.dp(1)

        width: Units.dp(10)//Math.min(parent.width/2, Math.max(badgeLabel.width,
                //badgeLabel.height) + Units.dp(2))
        height: width
        
        visible: indicator.badge !== ""

        // Label {
        //     id: badgeLabel
        //     text: indicator.badge
        //     anchors.centerIn: parent
        //     color: Theme.dark.textColor
        // }
    }

    Popover {
        id: dropdown

        overlayLayer: "desktopOverlayLayer"

        height: content.status == Loader.Ready ? content.implicitHeight : Units.dp(250)
        width: Math.max(content.implicitWidth, Units.dp(300))

        View {
            anchors.fill: parent
            elevation: 2
            radius: Units.dp(2)
        }

        Loader {
            id: content
            sourceComponent: indicator.view
            //active: dropdown.showing

            anchors.fill: parent

            onStatusChanged: {
                if (status == Loader.Ready) {
                    print("Forcing focus!")
                    item.forceActiveFocus()
                }
            }
        }
    }
}
