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
import Material 0.3
import Material.ListItems 0.1 as ListItem
import Material.Extras 0.1
import Papyros.Desktop 0.1

Indicator {
    id: indicator

    iconSource: Qt.resolvedUrl("images/harddisk.svg")
    tooltip: qsTr("%1 storage devices").arg(deviceCount)
    visible: deviceCount > 0
    userSensitive: true

    property int deviceCount: ListUtils.filteredCount(hardware.storageDevices, function(device) {
        return !device.ignored
    })

    view: Column {

        Repeater {
            model: hardware.storageDevices
            delegate: ListItem.Standard {
                text: modelData.name
                visible: !modelData.ignored

                iconSource: {
                    if (modelData.iconName.indexOf("harddisk") !== -1) {
                        return Qt.resolvedUrl("images/harddisk.svg")
                    } else if (modelData.iconName.indexOf("usb") !== -1) {
                        return "icon://device/usb"
                    } else {
                        return Qt.resolvedUrl("images/harddisk.svg")
                    }
                }

                onClicked: {
                    Qt.openUrlExternally(modelData.filePath)
                    indicator.close()
                }
            }
        }
    }
}
