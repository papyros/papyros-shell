/*
* Papyros SDDM theme - The SDDM theme for Papyros following Material Design
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
import QtQuick.Layouts 1.1
import Material 0.2
import Material.Extras 0.1

View {
    elevation: 2
    radius: Units.dp(2)

    anchors.verticalCenter: parent.verticalCenter

    width: selected ? Units.dp(230) : Units.dp(180)
    height: selected ? Units.dp(240) : Units.dp(190)

    property bool selected: selectedUser == index

    onSelectedChanged: {
        if (selected)
            field.forceActiveFocus()
    }

    Behavior on width {
        NumberAnimation { duration: 250 }
    }

    Behavior on height {
        NumberAnimation { duration: 250 }
    }

    Ink {
        anchors.fill: parent

        z: 0

        onClicked: {
            if (selected) {
                selectedUser = -1
            } else {
                selectedUser = index
            }
        }
    }

    Column {
        id: column

        width: parent.width

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: Units.dp(32)
        }

        CircleImage {
            id: image

            anchors.horizontalCenter: parent.horizontalCenter

            visible: status == Image.Ready && String(source).indexOf("sddm/faces/default.face.icon") == -1
            width: Units.dp(80)
            height: width
            source: icon

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: Qt.rgba(0,0,0,0.3)
                radius: width/2
            }
        }

        Item {
            anchors.horizontalCenter: parent.horizontalCenter
            width: image.width
            height: width
            visible: !image.visible

            Icon {
                anchors.centerIn: parent
                name: "action/account_circle"
                size: Units.dp(95)
            }
        }

        Item {
            width: parent.width
            height: Units.dp(24)
        }

        Label {
            id: label
            text: realName || name
            height: visible ? implicitHeight + Units.dp(8) : Units.dp(32)
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter

            font.pixelSize: Units.dp(18)
        }

        Item {
            width: parent.width
            height: Units.dp(24)
        }

        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            width: Units.dp(250) - parent.anchors.margins * 2
            height: visible ? field.height : 0

            visible: opacity > 0
            opacity: selected ? 1 : 0

            spacing: Units.dp(8)

            Behavior on height {
                NumberAnimation { duration: 200 }
            }

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }

            onVisibleChanged: {
                if (!visible)
                    field.text = ""
            }

            TextField {
                id: field
                width: parent.width
                placeholderText: "Password"
                echoMode: TextInput.Password

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter

                onAccepted: {
                    background.open(primaryScreen.width/2, primaryScreen.height/2)
                    timer.start()
                }
            }

            IconButton {
                Layout.alignment: Qt.AlignVCenter
                iconName: "content/send"
                enabled: field.text != ""

                onClicked: {
                    field.accepted()
                }
            }
        }
    }

    Timer {
        id: timer
        interval: 500
        onTriggered: sddm.login(name, field.text, selectedSession)
    }
}
