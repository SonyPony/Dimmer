import QtQuick 2.0
import "../controls" as Controls
import "../dialogs" as Dialogs
import "../../responsivity/responsivityLogic.js" as RL
import "../screens" as Screens

Rectangle {
    Controls.Graph {
        id: graph

        width: parent.width
        height: parent.height - pointDialog.buttonHeight

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

        width: parent.width
        height: RL.calcSize("height", 210)
        buttonHeight: RL.calcSize("height", 60)

        anchors.bottom: parent.bottom
    }

    Screens.LockScreen {
        active: (tempData.actualChannel == -1)
        text: qsTr("You haven't chosen desired room.")
    }
}
