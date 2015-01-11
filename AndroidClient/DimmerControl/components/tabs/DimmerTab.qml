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

        color: "lightGray"
        activeColor: "#76C012"
        toggleColor: "gray"
        lineWidth:  RL.calcSize("width", 20)
        toggleSize: RL.calcSize("width", 35)
        minimum: 0
        maximum: 100

        onValueChanged: socket.sendTextMessage(slider.value)
    }

    Controls.Switch {
        x: 20
        y: 230

        width: 100
        height: 30
    }

    Controls.Switch {
        x: 20
        y: 300

        width: 100
        height: 30
    }

    Controls.CircleProgressBar {
        y: 40
        x: 40
        height: 150
        width: 150

        maximum: 100
        minimum: 0
        value: slider.value
        lineWidth: RL.calcSize("width", 20)
        activeColor: "#76C012"
        textColor: "gray"
        grooveColor: "lightGray"
    }
}
