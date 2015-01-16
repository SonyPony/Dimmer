import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import "../controls" as Controls
import "../../responsivity/responsivityLogic.js" as RL

Rectangle {
    Controls.Slider {
        id: slider

        width: parent.width
        height: parent.height

        enabled: powerSwitch.checked
        color: "lightGray"
        activeColor: "#76C012"
        toggleColor: "gray"
        lineWidth:  RL.calcSize("width", 20)
        toggleSize: RL.calcSize("width", 35)
        minimum: 0
        maximum: 100

       // onValueChanged: socket.sendTextMessage(slider.value)
    }

    Controls.Switch {
        id: powerSwitch

        x: 170
        y: 450

        width: 85
        height: 25

        onCheckedChanged: if(!checked)
                              slider.setValue(0)
    }

    Controls.CircleProgressBar {
        y: 40
        x: 100
        height: 150
        width: 150

        maximum: 10.0
        minimum: 0
        value: slider.value / 10.0
        lineWidth: RL.calcSize("width", 20)
        activeColor: "#76C012"
        textColor: "gray"
        grooveColor: "lightGray"
    }

    Rectangle {
        color: "orange"
        anchors.fill: offButton
    }

    Controls.OffButton {
        id: offButton

        y: 200
        width: RL.calcSize("width", 140)
        height: 300
        color: "gray"
        activeColor: "orange"
    }
}
