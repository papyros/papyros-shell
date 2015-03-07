import QtQuick 2.2
import Material 0.1

Icon {
    id: icon

    property string tooltip

    onTooltipChanged: {
        if (mouseArea.containsMouse)
            indicator.tooltip = tooltip
    }

    color: "white"
    size: iconSize

    MouseArea {
        id: mouseArea

        width: icon.width + iconsRow.spacing
        height: indicator.height
        hoverEnabled: true
        anchors.centerIn: parent
        acceptedButtons: Qt.NoButton

        onEntered: indicator.tooltip = Qt.binding(function() { return icon.tooltip })
        onExited: indicator.tooltip = ""
    }
}
