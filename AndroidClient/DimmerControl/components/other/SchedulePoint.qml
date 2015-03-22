import QtQuick 2.0

import "../../responsivity/responsivityLogic.js" as RL
import "../../logic/messageController.js" as Socket

Item {
    id: pointPositioner

    property int hour: -1
    property int minute: 0
    property real dutyCycle: 0

    property bool timeChanged: false
    property int newHour
    property int newMinute
    property bool inited: false
    property bool done: false

    width: RL.calcSize("height", 23)
    height: width

    onYChanged: {
        var closestLine = -1
        var restOfDCL
        var piece = internal.yAxisY[0] - internal.yAxisY[1]

        for(var key in internal.yAxisY)
            if(Math.abs((pointPositioner.y + pointPositioner.height / 2) - internal.yAxisY[key]) < piece) {
                closestLine = key
                restOfDCL = Math.floor(Math.abs(internal.yAxisY[closestLine] - pointPositioner.y - pointPositioner.height / 2) / piece * 10)
                break
            }
        pointPositioner.dutyCycle = closestLine * 10 + restOfDCL
    }

    //dimming color
    onDutyCycleChanged: {
        point.opacity = 1 - dutyCycle / 100.0
        pointPositioner.parent.requestPaint()
    }

    Rectangle {     //edge because of white point would not be seen
        width: parent.width + 2 * RL.calcSize("height", 2) + ((Math.round(parent.width) % 2) ?0 : 1)
        height: width

        radius: width
        antialiasing: true
        border.color: root.primaryColor
        border.width: RL.calcSize("height", 2) + ((Math.round(parent.width) % 2) ?1 : 0)

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
        id: mouseArea

        anchors.fill: pointPositioner

        drag.axis: Drag.YAxis
        drag.target: pointPositioner
        drag.minimumY: internal.yAxisY[internal.yAxisY.length - 1] - pointPositioner.height / 2
        drag.maximumY: internal.yAxisY[0] - pointPositioner.height / 2

        drag.onActiveChanged: {
            if(drag.active)
                Socket.sendLock(tempData.actualChannel, "schedule", true)
            else
                Socket.sendLock(tempData.actualChannel, "schedule", false)
        }

        onClicked: deleteDialog.show(pointPositioner.x, pointPositioner.y, pointPositioner.hour * 100 + pointPositioner.minute)
    }
}
