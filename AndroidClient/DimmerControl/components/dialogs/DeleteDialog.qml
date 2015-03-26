import QtQuick 2.0
import "../../responsivity/responsivityLogic.js" as RL
import "../other" as Other

MoveablePointDialog {
    id: dialog

    text: qsTr("Delete")

    function clicked(x, y) {
        if(x >= dialog.x && x <= dialog.x + dialog.width && y >= dialog.y && y <= dialog.y + dialog.height)
            tempData.graph.removePoint(Math.floor(currentPointIndex / 100), currentPointIndex % 100, true)
        dialog.hide()
    }
}

