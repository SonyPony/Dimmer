import QtQuick 2.0
import "../dialogs" as Dialogs
import "../../responsivity/responsivityLogic.js" as RL
import "../../logic/messageController.js" as Socket

Canvas {
    id: canvas

    property real valuesCountX
    property real valuesCountY
    property real minimumX
    property real minimumY
    property real stepX
    property real stepY
    property color textColor
    property color lineColor
    property alias internal: internal
    property int timeLineHour: 2
    property int timeLineMinute: 30

    onTimeLineHourChanged: canvas.requestPaint()
    onTimeLineMinuteChanged: canvas.requestPaint()

    //private
    QtObject {
        id: internal
        property var xAxisX: new Array
        property var yAxisY: new Array
        property var points

        Component.onCompleted: points = {}
    }

    Component.onCompleted: tempData.graph = canvas

    Dialogs.DeleteDialog {
        id: deleteDialog
        z: 1
    }

    Dialogs.MoveablePointDialog {
        id: dclInfo
        z: 1
    }

    Repeater {      //Y axis
        model: valuesCountY
        delegate: Rectangle {
            y: (canvas.height - height - RL.calcSize("height", 40)) - modelData * ((canvas.height - height - RL.calcSize("height", 40)) / valuesCountY) + height

            width: RL.calcSize("width", 25)
            height: RL.calcSize("height", 2)

            color: lineColor

            onYChanged: internal.yAxisY[modelData] = y

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

            onXChanged: internal.xAxisX[modelData] = x
            Component.onCompleted: canvas.requestPaint()

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

    Rectangle {
        id: timeLine

        color: root.primaryColor
        width: RL.calcSize("width", 2)
        height: canvas.y + canvas.height - RL.calcSize("height", 40)
    }

    MouseArea {
        id: graphMouseArea

        anchors.fill: parent
        onClicked: if(deleteDialog.opacity)
                       deleteDialog.clicked(mouse.x, mouse.y)
    }

    onPaint: {
        var ctx = canvas.getContext('2d');
        var formula;
        var previous = false
        var margins = RL.calcSize("width", 20)
        var size = RL.calcSize("height", 5)

        ctx.clearRect(x, y, width, height)
        ctx.beginPath()
        ctx.fillStyle = root.secondaryColor

        timeLine.x = Math.floor(internal.xAxisX[Math.floor(canvas.timeLineHour / 2) + 1] + ((canvas.timeLineMinute + (canvas.timeLineHour % 2) * 60) / 120) * canvas.width / (canvas.valuesCountX + 1) - timeLine.width / 2)

        for(var key in internal.points) {
            if(previous) {      //if it is not first point
                var pointCenterX = previous.x + previous.width / 2;
                var pointCenterY = previous.y + previous.height / 2;

                var relativeWidth = internal.points[key].x - previous.x - previous.width / 4;   //width between 2 points
                var relativeHeight = previous.y - internal.points[key].y;   //height between 2 points

                //calc num of particles according to distance between 2 points
                var numberOfParticles = Math.floor(Math.sqrt(Math.pow(relativeWidth, 2) + Math.pow(relativeHeight, 2)) / margins);

                for(var i = 1; i <= numberOfParticles; i++) {
                    var fraction = i / numberOfParticles;
                    ctx.roundedRect(relativeWidth * fraction + pointCenterX - size / 2, pointCenterY - (relativeHeight * fraction), size, size, size, size);
                }
            }
            ctx.fill();
            previous = internal.points[key];
        }
        ctx.closePath()
    }

    function addPoint(hour, minute, DCL, broadcast) {
        var component = Qt.createComponent("../other/SchedulePoint.qml");
        var object = component.createObject(canvas);

        object.hour = hour;
        object.minute = minute;

        //because of binding loop
        //                                  evenHour                    +      remainingMinutes              *              1pieceWidth                 - objectWidth      - halfOfLine
        object.x = Math.floor(internal.xAxisX[Math.floor(hour / 2) + 1] + ((minute + (hour % 2) * 60) / 120) * canvas.width / (canvas.valuesCountX + 1) - object.width / 2)
        //             DCL in decade -> DCL % 10 == 0    - half of width    -    height between 2 points            *       rest / 10
        object.y = internal.yAxisY[Math.floor(DCL / 10)] - object.width / 2 - (internal.yAxisY[0] - internal.yAxisY[1]) * ((DCL % 10) / 10.0)

        if(internal.points[hour * 100 + minute]) //overwrite point
            removePoint(hour, minute)

        object.inited = true
        internal.points[hour * 100 + minute] = object;
        canvas.requestPaint();
        deleteDialog.hide()

        if(broadcast)
            Socket.sendSchedulePoint(tempData.actualChannel, hour, minute, DCL)
    }

    function pop(list, index) {
        var newList = new Array

        for(var key in list)
            if(key != index)
                newList[key] = list[key]

        return newList
    }

    function removePoint(hour, minute, broadcast) {
        internal.points[hour * 100 + minute].destroy()
        internal.points = pop(internal.points, hour * 100 + minute)
        canvas.requestPaint();

        if(broadcast && tempData.actualChannel != -1)
            Socket.removeSchedulePoint(tempData.actualChannel, hour, minute)
    }
}
