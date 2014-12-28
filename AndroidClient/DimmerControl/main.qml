import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.1

import "components/controls" as Controls

ApplicationWindow {
    visible: true
    width: 480
    height: 854
    title: qsTr("Hello World")
    //visibility: Window.FullScreen

    Controls.Slider {
       // x: 0
        anchors.fill: parent

        color: "orange"
        lineWidth:  5
        toggleSize: 20
        minimum: 10
        maximum: 100
    }
}
