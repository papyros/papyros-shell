/*
 * Quantum Shell - The desktop shell for Quantum OS following Material Design
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
import QtSystemInfo 5.0 as SystemInfo

Object {
    id: batteryInfo

    property string chargerType
    property string currentFlow
    property string remainingCapacity
    property string maximumCapacity
    property string remainingChargingTime
    property string voltage
    property string chargingState
    property string status
    property string health

    property real percentCharged

    property bool isCharging
    property bool isLow

    property alias isValid: batinfo.valid

    SystemInfo.BatteryInfo {
        id: batinfo

        batteryIndex: 0

        onChargerTypeChanged: {
            if (type == SystemInfo.BatteryInfo.WallCharger) {
                batteryInfo.chargerType = "Wall Charger"
            } else if (type == SystemInfo.BatteryInfo.USBCharger) {
                batteryInfo.chargerType = "USB Charger"
            } else if (type == SystemInfo.BatteryInfo.VariableCurrentCharger) {
                batteryInfo.chargerType = "Variable Current Charger"
            } else {
                batteryInfo.chargerType = "Unknown Charger"
            }
        }

        onCurrentFlowChanged: {
            batteryInfo.currentFlow = flow + " mA"
        }

        onRemainingCapacityChanged: {
            batteryInfo.remainingCapacity = capacity
            updateBatteryLevel()
        }

        onRemainingChargingTimeChanged: {
            batteryInfo.remainingChargingTime = seconds + " s"
        }

        onVoltageChanged: {
            batteryInfo.voltage = voltage + " mV"
        }

        onChargingStateChanged: {
            if (state == SystemInfo.BatteryInfo.Charging) {
                batteryInfo.chargingState = "Charging"
                batteryInfo.isCharging = true
            } else if (state == SystemInfo.BatteryInfo.IdleChargingState) {
                batteryInfo.chargingState = "Idle Charging"
                batteryInfo.isCharging = true
            } else if (state == SystemInfo.BatteryInfo.Discharging) {
                batteryInfo.chargingState = "Discharging"
                batteryInfo.isCharging = false
            } else {
                batteryInfo.chargingState = "Unknown"
                batteryInfo.isCharging = false
            }
        }

        onLevelStatusChanged: {
            if (levelStatus == SystemInfo.BatteryInfo.LevelEmpty) {
                batteryInfo.status = "Empty"
                batteryInfo.isLow = true
            } else if (levelStatus == SystemInfo.BatteryInfo.LevelLow) {
                batteryInfo.status = "Low"
                batteryInfo.isLow = true
            } else if (levelStatus == SystemInfo.BatteryInfo.LevelOk) {
                batteryInfo.status = "Ok"
                batteryInfo.isLow = false
            } else if (levelStatus == SystemInfo.BatteryInfo.LevelFull) {
                batteryInfo.status = "Full"
                batteryInfo.isLow = false
            } else {
                batteryInfo.status = "Unknown"
                batteryInfo.isLow = false
            }
        }

        onHealthChanged: {
            if (health == SystemInfo.BatteryInfo.HealthOk)
                batteryInfo.health = "Ok"
            else if (health == SystemInfo.BatteryInfo.HealthBad)
                batteryInfo.health = "Bad"
            else
                batteryInfo.health = "Unknown"
        }

        function updateBatteryLevel() {
            print(remainingCapacity, maximumCapacity)
            batteryInfo.percentCharged = remainingCapacity/maximumCapacity
        }

        Component.onCompleted: {
            onChargerTypeChanged(batinfo.chargerType)
            onCurrentFlowChanged(batinfo.currentFlow)
            onRemainingCapacityChanged(batinfo.remainingCapacity)
            onRemainingChargingTimeChanged(batinfo.remainingChargingTime)
            onVoltageChanged(batinfo.voltage)
            onChargingStateChanged(batinfo.chargingState)
            onLevelStatusChanged(batinfo.levelStatus)
            onHealthChanged(batinfo.health)
        }
    }
}

