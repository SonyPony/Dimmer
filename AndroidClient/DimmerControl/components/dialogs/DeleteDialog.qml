import QtQuick 2.0
import "../../responsivity/responsivityLogic.js" as RL
import "../other" as Other

Rectangle {
    id: dialog

    property int currentPointIndex

    width: RL.calcSize("width", 85)
    height: RL.calcSize("height", 40)

    color: root.ternaryColor
    opacity: 0

    Behavior on opacity {
        NumberAnimation { duration: 500 }
    }

    Text {
        text: qsTr("Delete")
        color: "white"

        font.family: "Trebuchet MS"
        font.pixelSize: RL.calcSize("height", 23)

        anchors.centerIn: parent
    }

    Other.Triangle {
        id: pointingTriangle

        width: RL.calcSize("width", 12)
        height: RL.calcSize("height", 7)
        color: parent.color
    }

    function clicked(x, y) {
        if(x >= dialog.x && x <= dialog.x + dialog.width && y >= dialog.y && y <= dialog.y + dialog.height)
            canvas.removePoint(Math.floor(currentPointIndex / 100), currentPointIndex % 100)
        dialog.hide()
    }

    function hide() {
        graphMouseArea.z = 0
        dialog.opacity = 0
    }

    function show(x, y, index) {
        var rightMargin = RL.calcSize("width", 10)
        var bottomMargin = RL.calcSize("height", 10)
        var width = dialog.width
        var height = dialog.height

        dialog.opacity = 1
        dialog.currentPointIndex = index
        graphMouseArea.z = 1

        //fix x coord
        if(x + width + rightMargin > canvas.width) {
            dialog.x = canvas.width - width - rightMargin
            pointingTriangle.x = dialog.width - RL.calcSize("width", 10) - pointingTriangle.width
        }
        else if(x < RL.calcSize("width", 25) + rightMargin) {
            dialog.x = RL.calcSize("width", 25) + rightMargin
            pointingTriangle.x = RL.calcSize("width", 10)
        }
        else {
            dialog.x = x - rightMargin
            pointingTriangle.x = RL.calcSize("width", 10)
        }

        //fix y coord
        if(y < graph.y + bottomMargin + dialog.width) {
            dialog.y = RL.calcSize("height", 15) + bottomMargin + y
            pointingTriangle.y = - pointingTriangle.height
            pointingTriangle.rotation = 180
        }
        else {
            dialog.y = y - dialog.height - bottomMargin
            pointingTriangle.y = dialog.height
            pointingTriangle.rotation = 0
        }
    }
}

