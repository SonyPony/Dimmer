import QtQuick 2.0
import "../controls" as Controls

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

}
