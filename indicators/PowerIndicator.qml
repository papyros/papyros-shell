/*
 * Quantum Shell - The desktop shell for Quantum OS following Material Design
 * Copyright (C) 2014 Michael Spencer
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
import Material.ListItems 0.1 as ListItem
import ".."

import QtSystemInfo 5.0

Indicator {
    id: indicator

    icon: "device/battery_80"
    tooltip: "Power"

    BatteryInfo {
        id: batinfo

        monitorChargerType: true
        monitorCurrentFlow: true
        monitorRemainingCapacity: true
        monitorRemainingChargingTime: true
        monitorVoltage: true
        monitorChargingState: true
        monitorBatteryStatus: true

        onChargerTypeChanged: {
            if (type == 1) {
                chargertype.text = "Wall Charger"
            } else if (type == 2) {
                chargertype.text = "USB Charger"
            } else if (type == 3) {
                chargertype.text = "Variable Current Charger"
            } else {
                chargertype.text = "Unknown Charger"
            }
        }

        onCurrentFlowChanged: {
            /* battery parameter skipped */
            currentflow.text = flow + " mA"
        }

        onRemainingCapacityChanged: {
            /* battery parameter skipped */
            remainingcapacity.text = capacity + getEnergyUnit()
            updateBatteryLevel()
        }

        onRemainingChargingTimeChanged: {
            /* battery parameter skipped */
            remainingchargingtime.text = seconds + " s"
        }

        onVoltageChanged: {
            /* battery parameter skipped */
            voltagetext.text = voltage + " mV"
        }

        onChargingStateChanged: {
            /* battery parameter skipped */
            if (state == 1) {
                chargeState.text = "Not Charging"
            } else if (state == 2) {
                chargeState.text = "Charging"
            } else if (state == 3) {
            chargeState.text = "Discharging"
            } else {
                chargeState.text = "Unknown"
            }
        }

        onBatteryStatusChanged: {
            /* battery parameter skipped */
            if (status == 1) {
                batStat.text = "Empty"
            } else if (status == 2) {
                batStat.text = "Low"
            } else if (status == 3) {
                batStat.text = "Ok"
            } else if (status == 4) {
                batStat.text = "Full"
            } else {
                batStat.text = "Unknown"
            }
        }

        function getEnergyUnit() {
                          if (energyUnit == 1) {
                              return " mAh"
                          } else if (energyUnit == 2) {
                              return " mWh"
                        } else {
                              return " ???"
                        }
        }

        function updateBatteryLevel() {
            var battery = 0
            level.text = (100/batinfo.maximumCapacity(battery)*batinfo.remainingCapacity(battery)).toFixed(1) + "%"
        }

        Component.onCompleted: {
            var battery = 0
            onChargerTypeChanged(chargerType)
            onCurrentFlowChanged(battery, currentFlow(battery))
            onRemainingCapacityChanged(battery, remainingCapacity(battery))
            onRemainingChargingTimeChanged(battery, remainingChargingTime(battery))
            onVoltageChanged(battery, voltage(battery))
            onChargingStateChanged(battery, chargingState(battery))
            onBatteryStatusChanged(battery, batteryStatus(battery))
            maximum.text = maximumCapacity(battery) + getEnergyUnit()
        }
    }

    DropDown {
        showing: true

    }
}
