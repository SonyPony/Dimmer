import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import "../controls" as Controls
import "../screens" as Screens
import "../../responsivity/responsivityLogic.js" as RL

Rectangle {
    property alias value: slider.value

    Controls.Slider {
        id: slider

        width: parent.width
        height: parent.height

        enabled: powerButton.active
        color: root.lineColor
        activeColor: root.primaryColor
        toggleColor: root.secondaryColor
        lineWidth:  RL.calcSize("height", 20)
        toggleSize: RL.calcSize("height", 35)
        minimum: 0
        maximum: 100
    }

    Controls.CircleProgressBar {
        height: RL.calcSize("height", 150)
        width: RL.calcSize("height", 150)

        maximum: 10.0
        minimum: 0
        value: 10.0 - root.luminosity / 25.5
        lineWidth: RL.calcSize("height", 20)
        activeColor: root.primaryColor
        textColor: root.secondaryColor
        grooveColor: root.lineColor

        anchors.top: parent.top
        anchors.topMargin: RL.calcSize("height", 40)
        anchors.left: parent.left
        anchors.leftMargin: RL.calcSize("width", 40)
    }

    Controls.OffButton {
        id: powerButton

        width: RL.calcSize("height", 153)
        height: RL.calcSize("height", 159)

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: RL.calcSize("height", 40)
        anchors.leftMargin: RL.calcSize("width", 40)

        onActiveChanged: if(!active)
                              slider.setValue(0)
    }

    Screens.LockScreen {
        opacity: slider.lock
    }
}
