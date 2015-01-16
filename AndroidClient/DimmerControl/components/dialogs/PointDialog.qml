import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import "../controls" as Controls
import "../../responsivity/responsivityLogic.js" as RL

Item {
    property alias hours: hourSpinBox.value
    property alias minutes: minuteSpinBox.value
    property alias dutyCycle: dclInput.text

    Behavior on y {
        NumberAnimation { easing.type: Easing.InOutQuad; duration: 500 }
    }

    Rectangle {
        color: "#EEEEEE"
        opacity: 0.7

        anchors.fill: parent
    }

    Controls.TouchSpinBox {     //hours
        id: hourSpinBox
        title: "Hours"

        width: RL.calcSize("width", 100)
        height: RL.calcSize("height", 100)

        edgeColor: "#76C012"
        textColor: "gray"

        count: 24
        minimum: 0
        step: 1

        anchors.topMargin: RL.calcSize("height", 30)
        anchors.leftMargin: RL.calcSize("width", 30)
        anchors.top: parent.top
        anchors.left: parent.left
    }

    Controls.TouchSpinBox {     //minutes
        id: minuteSpinBox
        title: "Minutes"

        width: hourSpinBox.width
        height: hourSpinBox.height

        edgeColor: "#76C012"
        textColor: "gray"

        count: 60
        minimum: 0
        step: 1

        anchors.topMargin: RL.calcSize("height", 30)
        anchors.leftMargin: RL.calcSize("width", 30)
        anchors.left: hourSpinBox.right
        anchors.top: parent.top
    }

    TextField {     //DCL
        id: dclInput

        horizontalAlignment: TextInput.AlignRight
        enabled: (pointDialog.y == addButton.y) ?false :true

        width: RL.calcSize("width", 120)
        height: RL.calcSize("height", 60)

        anchors.verticalCenter: minuteSpinBox.verticalCenter
        anchors.left: minuteSpinBox.right
        anchors.leftMargin: RL.calcSize("width", 20)

        style: TextFieldStyle {
            background: Rectangle {
                color: "transparent"
                radius: RL.calcSize("height", 5)

                border.width: RL.calcSize("height", 3)
                border.color: "#76C012"
            }

            textColor: "gray"
            font.family: "Trebuchet MS"
            font.pixelSize: dclInput.height * 0.7
        }
    }

    //ADDITIONAL TEXT
    Text {      //colon
        text: ":"
        color: "gray"

        font.family: "Trebuchet MS"
        font.pixelSize: RL.calcSize("height", 50)

        anchors.leftMargin: RL.calcSize("width", 10)
        anchors.topMargin: RL.calcSize("height", 15)
        anchors.left: hourSpinBox.right
        anchors.top: hourSpinBox.top
    }

    Text {      //DCL input title
        text: "Power"
        color: "gray"

        font.family: "Trebuchet MS"
        font.pixelSize: RL.calcSize("height", 20)

        anchors.bottom: dclInput.top
        anchors.horizontalCenter: dclInput.horizontalCenter
    }

    Text {      //percentage
        text: "%";
        color: "gray"

        font.family: "Trebuchet MS"
        font.pixelSize: dclInput.height * 0.7

        anchors.leftMargin: RL.calcSize("width", 10)
        anchors.left: dclInput.right
        anchors.verticalCenter: dclInput.verticalCenter
    }

    Controls.CloseButton {
        width: RL.calcSize("height", 30)
        height: width

        anchors.right: parent.right

        onClose: parent.y = addButton.y
    }
}
