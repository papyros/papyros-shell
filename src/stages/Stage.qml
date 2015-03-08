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
import QtQuick 2.2
import Material 0.1

/**
 * A stage is the view for a particular kind of screen. For example, there can mobile,
 * desktop, and TV stages.
 */
Item {
    /// Set to true to disable window management (in a mobile stage, for example)
    property bool fullscreenWindows: false

    property Component lockscreen

    property int leftMargin
    property int rightMargin
    property int topMargin
    property int bottomMargin
}
