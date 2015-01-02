import QtQuick 2.0
import "../controls" as Controls

Rectangle {
    Controls.Graph {
        width: parent.width
        height: parent.height
        valuesCountY: 10
        valuesCountX: 12
        minimumX: 0
        stepX: 2
        textColor: "gray"
        lineColor: "lightGray"

        minimumY: 0
        stepY: 10
    }
}
