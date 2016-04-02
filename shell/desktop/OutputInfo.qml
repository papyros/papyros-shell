/****************************************************************************
 * This file is part of Hawaii.
 *
 * Copyright (C) 2014-2016 Pier Luigi Fiorini
 *
 * Author(s):
 *    Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * $BEGIN_LICENSE:GPL2+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import Material 0.2

Rectangle {
    width: grid.implicitWidth + 16
    height: grid.implicitHeight + 16
    color: "#b2000000"

    GridLayout {
        id: grid
        columns: 2
        rowSpacing: 8
        columnSpacing: 8
        x: rowSpacing
        y: columnSpacing

        Text {
            text: "Name:"
            font.bold: true
            color: "white"

            Layout.alignment: Qt.AlignRight
        }
        Text {
            text: Screen.name
            font.bold: true
            font.underline: true
            color: "white"
        }

        Text {
            text: "Primary:"
            font.bold: true
            color: "white"

            Layout.alignment: Qt.AlignRight
        }
        Text {
            text: output.primary ? "Yes" : "No"
            font.bold: true
            color: output.primary ? "green" : "red"
        }

        Text {
            text: "Resolution:"
            font.bold: true
            color: "white"

            Layout.alignment: Qt.AlignRight
        }
        Text {
            text: Screen.width + "x" + Screen.height
            color: "white"
        }

        Text {
            text: "Physical Size:"
            font.bold: true
            color: "white"

            Layout.alignment: Qt.AlignRight
        }
        Text {
            text: output.physicalSize.width + "x" + output.physicalSize.height + " mm ("  + (output.physicalSize.width / 10).toFixed(2) + "x" + (output.physicalSize.height / 10).toFixed(2) + " cm)"
            color: "white"
        }

        Text {
            text: "Pixel Density:"
            font.bold: true
            color: "white"

            Layout.alignment: Qt.AlignRight
        }
        Text {
            text: Screen.pixelDensity.toFixed(2) + " dots/mm (" + (Screen.pixelDensity * 25.4).toFixed(2) + " dots/inch)"
            color: "white"
        }

        Text {
            text: "Logical Pixel Density:"
            font.bold: true
            color: "white"

            Layout.alignment: Qt.AlignRight
        }
        Text {
            text: Screen.logicalPixelDensity.toFixed(2) + " dots/mm (" + (Screen.logicalPixelDensity * 25.4).toFixed(2) + " dots/inch)"
            color: "white"
        }

        Text {
            text: "Device Pixel:"
            font.bold: true
            color: "white"

            Layout.alignment: Qt.AlignRight
        }
        Text {
            text: Units.dp(1).toFixed(2)
            color: "white"
        }

        Text {
            text: "Grid Unit:"
            font.bold: true
            color: "white"

            Layout.alignment: Qt.AlignRight
        }
        Text {
            text: Units.gu(1).toFixed(2)
            color: "white"
        }

        Text {
            text: "Device Pixel Ratio:"
            font.bold: true
            color: "white"

            Layout.alignment: Qt.AlignRight
        }
        Text {
            text: Screen.devicePixelRatio.toFixed(2)
            color: "white"
        }

        Text {
            text: "Available Virtual Desktop:"
            font.bold: true
            color: "white"

            Layout.alignment: Qt.AlignRight
        }
        Text {
            text: Screen.desktopAvailableWidth + "x" + Screen.desktopAvailableHeight
            color: "white"
        }

        Text {
            text: "Orientation:"
            font.bold: true
            color: "white"

            Layout.alignment: Qt.AlignRight
        }
        Text {
            text: orientationToString(Screen.orientation) + " (" + Screen.orientation + ")"
            color: "white"
        }

        Text {
            text: "Primary Orientation"
            font.bold: true
            color: "white"

            Layout.alignment: Qt.AlignRight
        }
        Text {
            text: orientationToString(Screen.primaryOrientation) + " (" + Screen.primaryOrientation + ")"
            color: "white"
        }
    }

    function orientationToString(o) {
        switch (o) {
        case Qt.PrimaryOrientation:
            return "Primary";
        case Qt.PortraitOrientation:
            return "Portrait";
        case Qt.LandscapeOrientation:
            return "Landscape";
        case Qt.InvertedPortraitOrientation:
            return "Inverted Portrait";
        case Qt.InvertedLandscapeOrientation:
            return "Inverted Landscape";
        }
        return "Unknown";
    }
}
