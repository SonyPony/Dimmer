import QtQuick 2.3

Canvas {
    id: canvas

    property color color
    property int lineWidth
    property int toggleSize
    property int value
    property real maximum
    property real minimum
    property int radius: height / 2 - toggleSize

    onPaint: {
        var ctx = canvas.getContext('2d');
        var centerX = width + x;
        var centerY = height / 2.0 + y;

        ctx.beginPath();
        ctx.moveTo(centerX, centerY)
        ctx.arc(centerX, centerY, radius, Math.PI / 2.0, Math.PI * 1.5, false)
        ctx.lineWidth = lineWidth
        ctx.strokeStyle = color;
        ctx.stroke()
    }

    Rectangle {
        id: toggleArea

        property bool activated: false

        width: parent.radius + parent.lineWidth * 2
        height: parent.toggleSize
        color: "transparent"
        transformOrigin: Item.Right

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            width: canvas.toggleSize
            height: width

            color: "red"
            antialiasing: true

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    function calcValue(x, y) {
        toggleArea.rotation = Math.atan(( canvas.height / 2.0 + canvas.y - y) / (canvas.width  + canvas.x - x)) / Math.PI * 180
        value = (toggleArea.rotation / 180.0 + 0.5) * (maximum - minimum) + minimum;
        console.log(value)
    }

    MouseArea {
        anchors.fill: parent

        onMouseXChanged: parent.calcValue(mouse.x, mouse.y)
        onMouseYChanged: parent.calcValue(mouse.x, mouse.y)
    }
}

