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
    property color textColor
    property color lineColor

    //private
    QtObject {
        id: internal
        property var xAxisX: new Array
        property var yAxisY: new Array
        property var points: new Array
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
        var formula;
        var previous = 0
        var margins = RL.calcSize("width", 20)
        var size = RL.calcSize("height", 5)

        ctx.clearRect(x, y, width, height)
        ctx.beginPath()
        ctx.fillStyle = "#B5E61D"

        for(var key in internal.points) {
            if(previous) {      //if it is not first point
                var pointCenterX = previous.x + previous.width / 2;
                var pointCenterY = previous.y + previous.height / 2;

                var relativeWidth = internal.points[key].x - previous.x - previous.width / 4;   //width between 2 points
                var relativeHeight = previous.y - internal.points[key].y;   //height between 2 points
                relativeHeight = (relativeHeight > 0) ?relativeHeight - previous.width / 2 :relativeHeight + previous.width / 2;

                //calc num of particles according to distance between 2 points
                var numberOfParticles = Math.floor(Math.sqrt(Math.pow(relativeWidth, 2) + Math.pow(relativeHeight, 2)) / margins);

                formula = function(pX) {return (relativeHeight / relativeWidth) * pX}   //create linear function

                for(var i = 1; i <= numberOfParticles; i++) {
                    var fraction = i / numberOfParticles;
                    ctx.roundedRect(relativeWidth * fraction + pointCenterX - size / 2, pointCenterY - (relativeHeight * fraction) - size / 2, size, size, size, size);
                }
            }
            ctx.fill();
            previous = internal.points[key];
        }
        ctx.closePath()
    }

    function addPoint(hour, minute, DCL) {
        var component = Qt.createComponent("../other/SchedulePoint.qml")
        var object = component.createObject(canvas)

        object.hour = hour
        object.minute = minute
        object.dutyCycle = DCL

        internal.points[hour * 100 + minute] = object
    }

    //test code
    Component.onCompleted: {
        canvas.addPoint(5, 20, 100)
        canvas.addPoint(12, 0, 0)
        canvas.addPoint(16, 0, 30)
        canvas.addPoint(20, 0, 60)

    }
}
