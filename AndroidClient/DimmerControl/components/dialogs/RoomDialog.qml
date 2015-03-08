import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import "../controls" as Controls
import "../../responsivity/responsivityLogic.js" as RL
import "../../logic/channelLogic.js" as CL

AddDialog {
    id: dialog

    property var pinList: [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27]
    property var adressList: ["72 - 0", "72 - 1", "72 - 2", "72 - 3", "73 - 0", "73 - 1", "73 - 2", "73 - 3",
                              "74 - 0", "74 - 1", "74 - 2", "74 - 3", "75 - 0", "75 - 1", "75 - 2", "75 - 3",
                              "76 - 0", "76 - 1", "76 - 2", "76 - 3", "77 - 0", "77 - 1", "77 - 2", "77 - 3",
                              "78 - 0", "78 - 1", "78 - 2", "78 - 3", "79 - 0", "79 - 1", "79 - 2", "79 - 3"
    ]

    buttonHeight: RL.calcSize("height", 60)
    acceptFunction: (function() {
        if(titleInput.text != "") {
            CL.addRoom(titleInput.text, pinSpinbox.value, sensorSpinbox.value)

            for(var key in pinList)
                if(pinSpinbox.value == pinList[key])
                    pinList.splice(key, 1)
            pinListChanged()
        }
        else
            errorDialog.error("Enter room label.")
    })

    Item {
        parent: content
        anchors.fill: parent

        Controls.TouchSpinBox {     //pin
            id: pinSpinbox
            title: "Dimmer pin"

            width: RL.calcSize("width", 100)
            height: RL.calcSize("height", 100)

            edgeColor: root.primaryColor
            textColor: root.secondaryColor

            fromList: true
            list: dialog.pinList

            anchors.topMargin: RL.calcSize("height", 30)
            anchors.leftMargin: RL.calcSize("width", 30)
            anchors.top: parent.top
            anchors.left: parent.left
        }

        Controls.TouchSpinBox {     //sensor
            id: sensorSpinbox
            title: "Sensor adress"

            width: pinSpinbox.width
            height: pinSpinbox.height

            edgeColor: root.primaryColor
            textColor: root.secondaryColor

            fromList: true
            list: dialog.adressList

            anchors.topMargin: RL.calcSize("height", 30)
            anchors.leftMargin: RL.calcSize("width", 30)
            anchors.left: pinSpinbox.right
            anchors.top: parent.top
        }

        Controls.TextInput {     //title
            id: titleInput

            enabled: !dialog.hidden

            width: RL.calcSize("width", 170)
            height: RL.calcSize("height", 60)
            title: "Room label"

            anchors.verticalCenter: sensorSpinbox.verticalCenter
            anchors.left: sensorSpinbox.right
            anchors.leftMargin: RL.calcSize("width", 20)

            onEnabledChanged: {
                if(enabled)
                    forceActiveFocus()
                focus = enabled
                text = ""
            }
        }
    }
}
