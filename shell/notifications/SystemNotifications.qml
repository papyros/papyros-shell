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
import Material.Extras 0.1

Object {
    property int soundVolume: sound.master
    property real batteryLevel: upower.primaryDevice
            ? upower.primaryDevice.percentage : 0

    onSoundVolumeChanged: notifications.add(soundNotification.createObject())

    property int lastLevel: 100

    onBatteryLevelChanged: {
        print("Battery level changed!")
        if (batteryLevel <= 30 && batteryLevel < lastLevel - 5) {
            lastLevel = batteryLevel
            notifications.add(batteryNotification.createObject())
        }

        if (batteryLevel > lastLevel) {
            lastLevel += 5
        }
    }

    Component {
        id: soundNotification

        SystemNotification {
            notificationId: -1
            iconName: sound.iconName
            percent: sound.master/100
        }
    }

    Component {
        id: batteryNotification

        SystemNotification {
            notificationId: -2
            iconName: upower.deviceIcon(upower.primaryDevice)
            summary: batteryLevel < 10 ? "Critically low battery!"
                                       : "Low battery!"
            body: upower.deviceSummary(upower.primaryDevice)

            duration: 5000
        }
    }
}
