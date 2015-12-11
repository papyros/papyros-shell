/*
 * This file is part of Green Island
 *
 * Copyright (C) 2015 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
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
import GreenIsland 1.0


ListModel {
    id: windows

    function findByWindow(window) {
        print("Looking for window", window.id)
        for (var i = 0; i < windows.count; i++) {
            var entry = windows.get(i);

            if (entry.window.id === window.id) {
                entry.index = i;
                return entry;
            }
        }
    }

    function removeById(id) {
        if (findById(id))
            remove(findById(id).index)
    }

    function moveFront(window) {
        var entry = findById(window.clientWindow.id)

        if (entry)
            move(entry.index, 0, 1)
    }

    function updateOrder() {
        for (var i = 0; i < windows.count; i++) {
            print("Updating z at ", i, "to", windows.count - i - 1)
            if (windows.get(i).window.type == ClientWindow.TopLevel)
                windows.get(i).item.z = windows.count - i - 1
        }
    }

    function findById(id) {
        print("Looking for id", id)
        for (var i = 0; i < windows.count; i++) {
            var entry = windows.get(i);

            if (entry.id === id) {
                entry.index = i;
                return entry
            }
        }
    }
}
