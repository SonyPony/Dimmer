import QtQuick 2.0

Canvas {
    id: canvas

    property color color
    property bool inverted: false

    antialiasing: true
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    onPaint: {
        var ctx = canvas.getContext('2d');

        ctx.clearRect(x, y, width, height)
        ctx.beginPath()
        ctx.fillStyle = canvas.color;

        ctx.moveTo(0, canvas.height * canvas.inverted)
        ctx.lineTo(canvas.width, canvas.height * canvas.inverted)
        ctx.lineTo(canvas.width / 2.0, canvas.height * (!canvas.inverted))
        ctx.lineTo(0, canvas.height * canvas.inverted)

        ctx.fill()
        ctx.closePath()
    }
}
