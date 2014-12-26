import QtQuick 2.3
import QtQuick.Controls 1.2
import CircleSlider 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    CircleSlider {
        id: slider
        x: parent.x + parent.width - width / 2 + 1
        y: 0
        width: 400
        height: 400
        grooveWidth: 10
        grooveColor: "orange"

    }


    MouseArea {
        anchors.fill: slider
        onPositionChanged: {
            //if(mouse.pressed) {
                slider.mouseMove(Qt.point(mouse.x, mouse.y))
            //}
        }
    }
}
