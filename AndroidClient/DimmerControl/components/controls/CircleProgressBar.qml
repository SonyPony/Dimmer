import QtQuick 2.0

Canvas {
    id: canvas

    property color grooveColor
    property color activeColor
    property color textColor
    property int lineWidth
    property int value
    property int maximum
    property int minimum

    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    onValueChanged: requestPaint()

    Text {
        id: valueText

        text: parent.value

        color: textColor

        font.family: "Trebuchet MS"
        font.pixelSize: Math.min(parent.width, parent.height) * 0.3

        anchors.centerIn: parent
    }

    Text {
        text: "Lux"

        color: activeColor

        font.family: "Trebuchet MS"
        font.pixelSize: Math.min(parent.width, parent.height) * 0.1

        anchors.top: valueText.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    onPaint: {
        var ctx = canvas.getContext('2d');

        var centerX = width / 2;
        var centerY = height / 2;
        var percentageValue = (value- minimum) / (maximum - minimum);
        var startAngle = Math.PI * 1.5;

        ctx.clearRect(0, 0, width, height);
        ctx.lineWidth = lineWidth;

        ctx.strokeStyle = grooveColor;
        ctx.beginPath();

        ctx.arc(centerX, centerY, Math.min(width / 2, height / 2) - lineWidth / 2, 0, Math.PI * 2)
        ctx.stroke()
        ctx.closePath();


        ctx.strokeStyle = activeColor;
        ctx.beginPath();
        ctx.arc(centerX, centerY, Math.min(width / 2, height / 2) - lineWidth / 2, startAngle, 2 * Math.PI * percentageValue + startAngle);
        ctx.stroke();
        ctx.closePath();
    }
}
