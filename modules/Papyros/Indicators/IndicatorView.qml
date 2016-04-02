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
import Material 0.3
import Material.Extras 0.1
import Papyros.Components 0.1

PanelItem {
    id: indicatorView

    tintColor: containsMouse || selected
            ? defaultColor == Theme.dark.iconColor ? Qt.rgba(0,0,0,0.2) : Qt.rgba(0,0,0,0.1)
            : Qt.rgba(0,0,0,0)

    width: smallMode ? indicator.text ? label.width + (height - label.height) : height
                     : indicator.text ? label.width + (Units.dp(30) - label.height)
                                      : circleImage.visible ? Units.dp(30 * 1.2)
                                                            : Units.dp(30)

    visible: !indicator.hidden && indicator.visible

    property bool smallMode: height < Units.dp(40)
    property Indicator indicator
    property color defaultColor: Theme.dark.iconColor
    property color defaultTextColor: Theme.dark.textColor
    tooltip: indicator ? indicator.tooltip : ""

    property int iconSize: height >= Units.dp(40) ? Units.dp(56) * 0.36 : height * 0.45

    selected: desktop.overlayLayer.currentOverlay == dropdown

    onClicked: toggle()

    function toggle() {
        if (selected)
            dropdown.close()
        else if (indicator.view)
            dropdown.open(indicatorView, 0, Units.dp(16))
    }

    Icon {
        anchors.centerIn: parent
        size: iconSize
        source: indicator.iconSource
        color: indicator.color.a == 0 ? defaultColor : indicator.color
        visible: !circleImage.visible
    }

    CircleImage {
        id: circleImage
        anchors.centerIn: parent
        width: iconSize * 1.2
        height: width
        source: visible ? indicator.iconSource : ""
        visible: indicator.circleClipIcon && String(indicator.iconSource).indexOf("icon://") == -1
    }

    Label {
        id: label
        anchors.centerIn: parent
        text: indicator.text
        color: indicator.color.a == 0 ? defaultTextColor : indicator.color
        font.pixelSize: Units.dp(14)
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

        onOpened: {
            content.item.forceActiveFocus()
        }

        Loader {
            id: content
            sourceComponent: indicator.view
            //active: dropdown.showing
            asynchronous: true

            anchors.fill: parent
        }
    }
}
