import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import "../controls" as Controls
import "../../responsivity/responsivityLogic.js" as RL

AddDialog {
    id: dialog

    property alias hours: hourSpinbox.value
    property alias minutes: minuteSpinbox.value
    property alias dutyCycle: dclInput.text

    buttonHeight: RL.calcSize("height", 60)
    delay: 200
    acceptFunction: (function() {
        if(parseInt(dutyCycle) + Math.abs(100 - parseInt(dutyCycle)) == 100)
            graph.addPoint(hours, minutes, dutyCycle, true)
        else
            errorDialog.error(qsTr("Enter number in range from 0 to 100."))
    })

    Behavior on width {
        NumberAnimation { duration: 400; easing.type: Easing.InOutQuad }
    }

    Item {
        parent: content
        anchors.fill: parent
        Controls.TouchSpinBox {     //hours
            id: hourSpinbox
            title: qsTr("Hours")

            width: RL.calcSize("width", 100)
            height: RL.calcSize("height", 100)

            edgeColor: root.primaryColor
            textColor: root.secondaryColor

            count: 24
            minimum: 0
            step: 1

            anchors.topMargin: RL.calcSize("height", 30)
            anchors.leftMargin: RL.calcSize("width", 30)
            anchors.top: parent.top
            anchors.left: parent.left
        }

        Controls.TouchSpinBox {     //minutes
            id: minuteSpinbox
            title: qsTr("Minutes")

            width: hourSpinbox.width
            height: hourSpinbox.height

            edgeColor: root.primaryColor
            textColor: root.secondaryColor

            count: 60
            minimum: 0
            step: 1

            anchors.topMargin: RL.calcSize("height", 30)
            anchors.leftMargin: RL.calcSize("width", 30)
            anchors.left: hourSpinbox.right
            anchors.top: parent.top
        }

        Controls.TextInput {     //DCL
            id: dclInput

            enabled: !dialog.hidden

            width: RL.calcSize("width", 120)
            height: RL.calcSize("height", 60)
            validator: RegExpValidator { regExp: /[1]?\d\d/ }
            title: qsTr("Power")

            anchors.verticalCenter: minuteSpinbox.verticalCenter
            anchors.left: minuteSpinbox.right
            anchors.leftMargin: RL.calcSize("width", 20)

            onEnabledChanged: {
                if(enabled)
                    forceActiveFocus()
                focus = enabled
            }
        }

        //ADDITIONAL TEXT
        Text {      //colon
            text: ":"
            color: root.secondaryColor

            font.family: "Trebuchet MS"
            font.pixelSize: RL.calcSize("height", 50)

            anchors.leftMargin: RL.calcSize("width", 10)
            anchors.topMargin: RL.calcSize("height", 15)
            anchors.left: hourSpinbox.right
            anchors.top: hourSpinbox.top
        }

        Text {      //percentage
            text: "%";
            color: root.secondaryColor

            font.family: "Trebuchet MS"
            font.pixelSize: dclInput.height * 0.7

            anchors.leftMargin: RL.calcSize("width", 10)
            anchors.left: dclInput.right
            anchors.verticalCenter: dclInput.verticalCenter
        }
    }
}
