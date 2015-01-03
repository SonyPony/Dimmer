import QtQuick 2.0

Canvas {
    id: canvas

    property color color

    onPaint: {
        var ctx = canvas.getContext('2d');

        ctx.fillStyle = canvas.color;

        ctx.moveTo(0, 0)
        ctx.lineTo(canvas.width, 0)
        ctx.lineTo(canvas.width / 2.0, canvas.height)
        ctx.lineTo(0, 0)

        ctx.fill()
    }
}
