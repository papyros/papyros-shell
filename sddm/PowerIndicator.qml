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
import Material.ListItems 0.1 as ListItem
import Papyros.Indicators 0.1

Indicator {
    id: indicator

    iconSource: "icon://action/power_settings_new"
    tooltip: "Power"
    visible: sddm.canSuspend || sddm.canHibernate || sddm.canPowerOff || sddm.canReboot

    view: Column {

        ListItem.Standard {
            iconSource: Qt.resolvedUrl("images/sleep.svg")
            text: "Sleep"
            visible: sddm.canSuspend
            onClicked: {
                sddm.suspend()
                indicator.close()
            }
        }

        ListItem.Standard {
            iconName: "file/file_download"
            text: "Suspend to disk"
            visible: sddm.canHibernate
            onClicked: {
                sddm.hibernate()
                indicator.close()
            }
        }

        ListItem.Standard {
            iconName: "action/power_settings_new"
            text: "Power off"
            visible: sddm.canPowerOff
            onClicked: {
                sddm.powerOff()
                indicator.close()
            }
        }

        ListItem.Standard {
            iconSource: Qt.resolvedUrl("images/reload.svg")
            text: "Reboot"
            visible: sddm.canReboot
            onClicked: {
                sddm.reboot()
                indicator.close()
            }
        }
    }
}
