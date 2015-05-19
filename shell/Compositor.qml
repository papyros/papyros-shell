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
import QtQuick 2.2
import Material 0.1

MainView {
    id: root

    theme {
        accentColor: "#009688"
    }

    state: loader.status == Loader.Ready
            ? loader.item.hasErrors ? "error" : "default"
            : loader.status == Loader.Error ? "error" : "loading"

    states: [
        State {
            name: "error"

            PropertyChanges {
                target: errorView

                opacity: 1
            }
        },

        State {
            name: "loading"

            PropertyChanges {
                target: welcomeView

                opacity: 1
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "*"

            NumberAnimation {
                target: welcomeView
                properties: "opacity"
            }

            NumberAnimation {
                target: errorView
                properties: "opacity"
            }
        }
    ]

    onStateChanged: {
        if (state == "error")
            errorWave.open(width/2, height/2)
        else if (state == "default")
            background.close(width/2, height/2)
    }

    Rectangle {
        anchors.fill: parent
        color: background.color
    }

    Loader {
        id: loader

        anchors.fill: parent
        asynchronous: true

        Component.onCompleted: {
            var component = Qt.createComponent(Qt.resolvedUrl("Shell.qml"),
                    Component.Asynchronous)
            loader.sourceComponent = component
        }
    }

    Wave {
        id: background

        color: "#2196f3"

        opened: true
    }

    Column {
        id: welcomeView

        anchors.centerIn: parent

        opacity: 0
        spacing: Units.dp(15)

        populate: Transition {
            id: populateTransition
            SequentialAnimation {
                PropertyAction {
                    property: "opacity"; value: 0
                }

                PauseAnimation {
                    duration: (populateTransition.ViewTransition.index -
                            populateTransition.ViewTransition.targetIndexes[0]) * 250 + 100
                }

                ParallelAnimation {
                    NumberAnimation {
                        property: "opacity"; duration: 250
                        from: 0; to: 1
                    }

                    NumberAnimation {
                        property: "y"; duration: 250
                        from: populateTransition.ViewTransition.destination.y + Units.dp(50);
                        easing.type: Easing.OutQuad
                    }
                }
            }
        }

        ProgressCircle {
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter

            style: "display1"
            text: "Welcome"
            color: "white"
        }
    }

    Wave {
        id: errorWave
        color:"#f44336"
    }

    Column {
        id: errorView

        anchors.centerIn: parent
        width: parent.width * 0.7

        opacity: 0

        Icon {
            size: Units.dp(100)
            name: "alert/warning"
            color: "white"

            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item {
            width: parent.width
            height: Units.dp(20)
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            style: "display1"
            text: "Oh no! "
            color: "white"
        }

        Item {
            width: parent.width
            height: Units.dp(20)
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter

            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            wrapMode: Text.Wrap

            style: "title"
            color: "white"

            text: "The desktop failed to materialize"
        }

        Item {
            width: parent.width
            height: Units.dp(10)
        }

        Label {
            id: errorLabel
            anchors.horizontalCenter: parent.horizontalCenter

            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            wrapMode: Text.Wrap

            style: "subheading"
            color: "white"
            text: loader.status == Loader.Ready
                    ? loader.item.errorMessage
                    : loader.sourceComponent.errorString()
        }
    }
}
