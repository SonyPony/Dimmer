import QtQuick 2.0

import "../../responsivity/responsivityLogic.js" as RL

Item {
    property int hour: 0
    property int minute: 0
    property real dutyCycle: 0

    //                          evenHour                     +      remainingMinutes                    *              1pieceWidth                 - objectWidth - halfOfLine
    x: internal.xAxisX[((hour % 2) ?hour - 1 :hour) / 2 + 1] + ((minute + ((hour % 2) ?60 :0)) / 120.0) * canvas.width / (canvas.valuesCountX + 1) - width / 2 - RL.calcSize("height", 1)
    //        DCL in decade -> DCL % 10 == 0       - half of width -    height between 2 points            *       rest / 10
    y: internal.yAxisY[Math.floor(dutyCycle / 10)] - width / 2 - (internal.yAxisY[0] - internal.yAxisY[1]) * ((dutyCycle % 10) / 10.0)

    width: RL.calcSize("height", 15)
    height: width

    onDutyCycleChanged: {   //dimming color
        var rgbColor = parseInt(Math.floor(255.0 * (dutyCycle / 100.0)))
        point.color = "#" + rgbColor.toString(16) + rgbColor.toString(16) + rgbColor.toString(16)
    }

    Rectangle {     //edge because of white point would not be seen
        width: parent.width + 2 * RL.calcSize("height", 2) + ((Math.round(parent.width) % 2) ?1 : 0)
        height: width

        radius: width
        color: root.primaryColor
        antialiasing: true

        anchors.horizontalCenter: point.horizontalCenter
        anchors.verticalCenter: point.verticalCenter
    }

    Rectangle {
        id: point

        width: parent.width
        height: width

        radius: width
        color: "black"
        antialiasing: true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: canvas.removePoint(hour, minute)
    }
}
