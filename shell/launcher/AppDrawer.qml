/*
 * Papyros Shell - The desktop shell for Papyros following Material Design
 * Copyright (C) 2015 Michael Spencer
 *               2015 Bogdan Cuza
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
import QtQuick.Layouts 1.2
import Material 0.1
import Material.ListItems 0.1 as ListItem
import Papyros.Desktop 0.1

import ".."
import "../components"
import "../indicators"

Indicator {
    id: appDrawer

    iconName: "navigation/apps"
    tooltip: "Applications"

    view: FocusScope {
        implicitHeight: container.height + Units.dp(95 * 4) + Units.dp(48)
        implicitWidth: Units.dp(95 * 4) + Units.dp(16)

        Component.onCompleted: textField.forceActiveFocus()

        Rectangle {
            anchors.fill: parent
            color: "#f6f6f6"
            radius: Units.dp(2)
        }

        Rectangle {
            id: container

            radius: Units.dp(2)
            width: parent.width
            height: Units.dp(48)

            View {
                anchors {
                    topMargin: parent.radius
                    fill: parent
                }
                backgroundColor: "white"
                elevation: 1
            }

            RowLayout {
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: Units.dp(16)
                    rightMargin: Units.dp(16)
                }

                spacing: Units.dp(8)

                Icon {
                    Layout.alignment: Qt.AlignVCenter

                    name: "action/search"
                    color: Theme.light.hintColor
                }

                TextField {
                    id: textField

                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true

                    placeholderText: "Search..."
                    showBorder: false
                }
            }
        }

        Column {
            anchors.centerIn: listView
            visible: listView.visible && listView.contentHeight == 0

            spacing: Units.dp(8)

            Icon {
                anchors.horizontalCenter: parent.horizontalCenter
                name: "action/search"
                color: Theme.light.hintColor
                size: Units.dp(48)
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "No apps match your search"
                style: "subheading"
                font.pixelSize: Units.dp(18)
                color: Theme.light.hintColor
            }
        }

        ListView {
            id: listView

            anchors {
                left: parent.left
                right: parent.right
                top: container.bottom
                bottom: parent.bottom
            }

            visible: textField.text !== ""

            topMargin: Units.dp(8)
            bottomMargin: Units.dp(8)

            model: DesktopFiles.desktopFiles
            delegate: ListItem.Standard {
                action: AppIcon {
                    iconName: edit.iconName
                    name: edit.name
                    hasIcon: edit.hasIcon
                    anchors.fill: parent
                }

                text: edit.name
                visible: textField.text === "" ||
                        text.toLowerCase().indexOf(textField.text.toLowerCase()) !== -1
                height: visible ? implicitHeight : 0

                onClicked: {
                    edit.launch([])
                    desktop.overlayLayer.currentOverlay.close()
                }
            }
        }

        Scrollbar {
            flickableItem: listView
        }

        ListView {
            id: gridView

            visible: textField.text === ""

            anchors {
                left: parent.left
                right: parent.right
                top: container.bottom
                bottom: parent.bottom
                topMargin: Units.dp(8)
                bottomMargin: Units.dp(40)
                leftMargin: Units.dp(8)
                rightMargin: Units.dp(8)
            }

            orientation: Qt.Horizontal
            snapMode: ListView.SnapOneItem
            highlightFollowsCurrentItem: true
            highlightRangeMode: ListView.StrictlyEnforceRange
            highlightMoveDuration: 500
            currentIndex: 0

            model: Math.ceil(DesktopFiles.desktopFiles.rowCount()/pageCount)
            delegate: Grid {
                id: page

                property int pageIndex: index

                Repeater {
                    model: pageIndex == gridView.count - 1
                            ? DesktopFiles.desktopFiles.rowCount() % gridView.pageCount : gridView.pageCount
                    delegate: Item {
                        id: appIcon

                        property var edit: DesktopFiles.desktopFiles.get(index + page.pageIndex * gridView.pageCount)

                        width: gridView.width/4
                        height: gridView.height/4

                        Ink {
                            anchors.fill: parent
                            onClicked: {
                                appIcon.edit.launch([])
                                desktop.overlayLayer.currentOverlay.close()
                            }
                        }

                        Column {
                            anchors.centerIn: parent
                            spacing: Units.dp(8)
                            width: parent.width - Units.dp(16)

                            AppIcon {
                                anchors.horizontalCenter: parent.horizontalCenter
                                height: Units.dp(40)
                                width: Units.dp(40)
                                iconName: appIcon.edit.iconName
                                name: appIcon.edit.name
                                hasIcon: appIcon.edit.hasIcon
                            }

                            Label {
                                text: appIcon.edit.name
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: parent.width
                                height: Units.dp(30)
                                horizontalAlignment: Text.AlignHCenter
                                elide: Text.ElideRight
                                wrapMode: Text.Wrap
                                maximumLineCount: 2
                            }
                        }
                    }
                }
            }

            property int pageCount: 16

            Component.onCompleted: print("COUNT:", model)
        }

        Row {
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: Units.dp(16)
            }

            spacing: Units.dp(16)
            visible: gridView.visible

            Repeater {
                model: gridView.model
                delegate: Rectangle {
                    color: index == gridView.currentIndex
                            ? Theme.dark.accentColor : "#ddd"
                    width: height
                    height: Units.dp(8)
                    radius: height/2
                }
            }
        }
    }

    Connections {
        target: shell

        onSuperPressed: selected ? selectedIndicator = null
                                 : selectedIndicator = appDrawer
    }
}
