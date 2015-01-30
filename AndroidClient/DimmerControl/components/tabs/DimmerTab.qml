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
        color: root.lineColor
        activeColor: root.primaryColor
        toggleColor: root.secondaryColor
        lineWidth:  RL.calcSize("height", 20)
        toggleSize: RL.calcSize("height", 35)
        minimum: 0
        maximum: 100

        onValueChanged: dimmingBulb.opacity = value / 100.0
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
        value: 10.0 - root.luminosity / 25.5
        lineWidth: RL.calcSize("height", 20)
        activeColor: root.primaryColor
        textColor: root.secondaryColor
        grooveColor: root.lineColor

    Rectangle {
        color: "orange"
        anchors.fill: offButton
    }

    Controls.OffButton {
        id: offButton

        y: 200
        width: RL.calcSize("width", 140)
        height: 300
        color: root.secondaryColor
        activeColor: "orange"
    }
}
