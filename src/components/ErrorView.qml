Item {
	property alias text: label.text

	ColumnLayout {
		id: column
        anchors.centerIn: parent
        spacing: Units.dp(8)

        Icon {
            Layout.alignment: Qt.AlignHCenter
            
            name: "alert/warning"
            color: Palette.colors["red"]["500"]
            size: Units.dp(48)
        }

        Label {
        	id: label
            Layout.alignment: Qt.AlignHCenter

            style: "subheading"
        }
    }

    Item {
    	anchors {
    		horizontalCenter: parent.horizontalCenter
    		top: column.bottom
    		bottom: parent.bottom
    	}

    	Button {
	        Layout.alignment: Qt.AlignHCenter
	        text: "View Details"
	        textColor: Palette.colors["red"]["500"]
	    }
	}
}