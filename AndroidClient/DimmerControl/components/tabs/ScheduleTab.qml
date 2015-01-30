import QtQuick 2.0
import "../controls" as Controls
import "../dialogs" as Dialogs
import "../../responsivity/responsivityLogic.js" as RL

Rectangle {
    Controls.Graph {
        id: graph

        width: parent.width
        height: parent.height - addButton.height

        valuesCountY: 11
        minimumY: 0
        stepY: 10

        valuesCountX: 12
        minimumX: 0
        stepX: 2

        textColor: root.secondaryColor
        lineColor: root.lineColor
    }


    Dialogs.PointDialog {
        id: pointDialog

        y: addButton.y

        width: parent.width
        height: RL.calcSize("height", 150)
    }

    Rectangle {
        id: addButton

        width: parent.width
        height: RL.calcSize("height", 60)

        color: "#76C012"

        anchors.bottom: parent.bottom

        Text {
            text: qsTr("Add")
            color: "white"

            font.family: "Verdana"
            font.pixelSize: RL.calcSize("height", 30)

            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                if(pointDialog.y != addButton.y) {  //hided
                    if(parseInt(pointDialog.dutyCycle) >= 0 && parseInt(pointDialog.dutyCycle) <= 100)
                        graph.addPoint(pointDialog.hours, pointDialog.minutes, parseInt(pointDialog.dutyCycle))
                    else
                        errorDialog.error("Enter number in range from 0 to 100")
                }
                pointDialog.y = (pointDialog.y == addButton.y) ?parent.y - pointDialog.height :addButton.y
            }
        }
    }
}
