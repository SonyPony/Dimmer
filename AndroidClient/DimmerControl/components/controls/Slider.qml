import QtQuick 2.3

import "../../logic/messageController.js" as Socket

Canvas {
    id: canvas

    property color color
    property color toggleColor
    property color activeColor
    property int lineWidth
    property int toggleSize
    property int value : 0
    property real maximum
    property real minimum
    property int radius: height / 2 - toggleSize
    property int counter

    onValueChanged: sendValue()
   // onActiveColorChanged: canvas.requestPaint()
    onValueChanged: Socket.sendDim(value, tempData.actualChannel)
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
    onLockChanged:  Socket.sendLock(tempData.actualChannel, lock)

    Behavior on value {
        NumberAnimation { duration: 1000 }
    }

    onPaint: {      //draw groove//
        var ctx = canvas.getContext('2d');
        var centerX = width;
        var centerY = height / 2.0;

        ctx.clearRect(x, y, width, height)

        ctx.lineWidth = lineWidth
        ctx.strokeStyle = color
        ctx.beginPath();
        //ctx.moveTo(centerX, centerY)
        ctx.arc(centerX, centerY, radius, Math.PI / 2.0, Math.PI * 1.5, false)
        ctx.stroke()
        ctx.closePath();

        ctx.lineWidth = lineWidth
        ctx.strokeStyle = activeColor;
        ctx.beginPath();
        //ctx.moveTo(centerX, centerY)
        ctx.arc(centerX, centerY, radius, Math.PI / 2.0, Math.PI*((toggleArea.rotation + 180) /180.0) , false)
        ctx.stroke()
        ctx.closePath();
    }


    Rectangle {     //rotating area//
        id: toggleArea

        width: parent.radius + parent.lineWidth / 2 + (toggleSize - lineWidth) / 2
        height: parent.toggleSize

        color: "transparent"
        rotation: -90
        transformOrigin: Item.Right

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {     //toggle button//
            width: canvas.toggleSize
            height: width;
            radius: width

            color: canvas.toggleColor
            antialiasing: true

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Text {      //text with slider value
        id: valueText

        text: "0"
        color: root.secondaryColor

        font.family: "Trebuchet MS"
        font.pixelSize: 80

        anchors.right: parent.right
        anchors.rightMargin: parent.lineWidth
        anchors.verticalCenter: parent.verticalCenter

        onTextChanged: canvas.requestPaint()
    }

    function calcValue(x, y) {
        toggleArea.rotation = Math.atan(( canvas.height / 2.0 - y) / (canvas.width - x)) / Math.PI * 180
        value = (toggleArea.rotation / 180.0 + 0.5) * (maximum - minimum) + minimum;
        valueText.text = ((toggleArea.rotation / 180.0 + 0.5) * (maximum - minimum) + minimum).toFixed(0);
    }

    function setValue(arg) {
        value = arg;
        valueText.text = arg.toFixed(0);
        toggleArea.rotation = ((arg - minimum) / (maximum - minimum) - 0.5) * 180.0
    }

    MouseArea {
        anchors.fill: parent

        onMouseXChanged: parent.calcValue(mouse.x, mouse.y)
        onMouseYChanged: parent.calcValue(mouse.x, mouse.y)
    }
}

