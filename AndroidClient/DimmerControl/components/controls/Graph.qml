import QtQuick 2.0
import "../dialogs" as Dialogs
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

    Dialogs.DeleteDialog {
        id: deleteDialog
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

        for(var key in internal.points) {
            if(previous) {      //if it is not first point
                var pointCenterX = previous.x + previous.width / 2;
                var pointCenterY = previous.y + previous.height / 2;

                var relativeWidth = internal.points[key].x - previous.x - previous.width / 4;   //width between 2 points
                var relativeHeight = previous.y - internal.points[key].y;   //height between 2 points
                relativeHeight = relativeHeight - ((relativeHeight > 0) - (relativeHeight < 0)) * (previous.width / 2)

                //calc num of particles according to distance between 2 points
                var numberOfParticles = Math.floor(Math.sqrt(Math.pow(relativeWidth, 2) + Math.pow(relativeHeight, 2)) / margins);

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
        var component = Qt.createComponent("../other/SchedulePoint.qml");
        var object = component.createObject(canvas);

        object.hour = hour;
        object.minute = minute;
        object.dutyCycle = DCL;

        if(internal.points[hour * 100 + minute]) //overwrite point
            removePoint(hour, minute)

        internal.points[hour * 100 + minute] = object;
        canvas.requestPaint();
    }

    function removePoint(hour, minute) {
        var container;

        internal.points[hour * 100 + minute].destroy()
        internal.points.splice(hour * 100 + minute, 1);

        container = internal.points;
        internal.points = new Array;

        for(var key in container) {
            var object = container[key];
            internal.points[object.hour * 100 + object.minute] = object;
        }

        canvas.requestPaint();
    }
}
