import QtQuick 2.0
import "../../responsivity/responsivityLogic.js" as RL

Canvas {
    id: canvas

    property real valuesCountX
    property real valuesCountY
    property real minimumX
    property real minimumY
    property real stepX
    property real stepY
    property color color
    property color textColor
    property color lineColor
    property var points: new Array

    Repeater {      //Y axis
        model: valuesCountY
        delegate: Rectangle {
            y: (canvas.height - height - RL.calcSize("height", 40)) - modelData * ((canvas.height - height - RL.calcSize("height", 40)) / valuesCountY) + height

            width: RL.calcSize("width", 25)
            height: RL.calcSize("height", 2)

            color: lineColor

            Text {
                text: modelData * stepY + minimumY
                color: textColor
                antialiasing: true

                font.family: "Trebuchet MS"
                font.pixelSize: RL.calcSize("height", 15)

                anchors.bottom: parent.top
                anchors.bottomMargin: RL.calcSize("height", 1)
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Repeater {      //X axis
        model: valuesCountX + 1
        delegate: Rectangle {
            x: modelData * (canvas.width / (valuesCountX + 1))
            y: canvas.y + canvas.height - RL.calcSize("height", 40)

            width: canvas.width / (valuesCountX + 1)
            height: RL.calcSize("height", 2)

            color: lineColor

            Rectangle {
                width: parent.height
                height: RL.calcSize("height", 10)

                color: parent.color
                visible: (modelData != valuesCountX && modelData != 0)

                anchors.right: parent.right

                Text {
                    text: modelData * stepX + minimumX
                    color: textColor

                    font.family: "Trebuchet MS"
                    font.pixelSize: RL.calcSize("height", 15)

                    anchors.top: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    onPaint: {
        var ctx = canvas.getContext('2d');


    }
}
