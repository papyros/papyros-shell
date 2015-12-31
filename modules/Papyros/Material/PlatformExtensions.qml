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
import QtQuick 2.0
import Material 0.1
import Papyros.Material 0.1
import Papyros.Desktop 0.1

Object {
    id: platformExtensions

    property color decorationColor: Theme.primaryDarkColor
    property var window: null

    readonly property real multiplier: Number(displaySettings.multiplier)

    Component.onCompleted: {
        if (decorationColor != "#000000")
            updateDecorationColor()
    }

    onDecorationColorChanged: {
        if (decorationColor != "#000000") {
            updateDecorationColor();
        }
    }

    function updateDecorationColor() {
        decorations.backgroundColor = decorationColor
        decorations.iconColor = Theme.lightDark(decorationColor, Theme.light.subTextColor,
                Theme.dark.subTextColor)
        decorations.textColor = Theme.lightDark(decorationColor, Theme.light.textColor,
                Theme.dark.textColor)
        decorations.update()
    }

    KQuickConfig {
        id: displaySettings

        file: "papyros-shell"
        group: "display"
        defaults: {
            "multiplier": "1.0"
        }
    }

    WindowDecorations {
        id: decorations
        window: platformExtensions.window
    }
}
