import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import "../controls" as Controls
import "../../responsivity/responsivityLogic.js" as RL
import "../../logic/channelLogic.js" as CL

AddDialog {
    id: dialog

    buttonHeight: RL.calcSize("height", 60)
    acceptFunction: (function() {
        if(titleInput.text != "")
            CL.addRoom(titleInput.text, pinSpinbox.value, sensorSpinbox.value, true)

        else
            errorDialog.error(qsTr("Enter room label."))
    })

    Item {
        parent: content
        anchors.fill: parent

        Controls.TouchSpinBox {     //pin
            id: pinSpinbox
            title: qsTr("Dimmer pin")

            width: RL.calcSize("width", 100)
            height: RL.calcSize("height", 100)

            edgeColor: root.primaryColor
            textColor: root.secondaryColor

            fromList: true
            list: tempData.pinList

            anchors.topMargin: RL.calcSize("height", 30)
            anchors.leftMargin: RL.calcSize("width", 30)
            anchors.top: parent.top
            anchors.left: parent.left
        }

        Controls.TouchSpinBox {     //sensor
            id: sensorSpinbox
            title: qsTr("Sensor adress")

            width: pinSpinbox.width
            height: pinSpinbox.height

            edgeColor: root.primaryColor
            textColor: root.secondaryColor

            fromList: true
            list: tempData.adressList

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
            title: qsTr("Room label")

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
