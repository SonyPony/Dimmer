import QtQuick 2.0
import "../controls" as Controls
import "../dialogs" as Dialogs
import "../../responsivity/responsivityLogic.js" as RL
import "../../logic/messageController.js" as Socket
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

        width: parent.width / 10
        height: RL.calcSize("height", 210)
        buttonHeight: RL.calcSize("height", 60)
        iconVisible: true
        active: enableToggle.active

        anchors.bottom: parent.bottom
        anchors.right: parent.right

        onWidthChanged: if(width <= parent.width / 10 )
                            hideContent()

        onHiddenChanged: {
            if(width) {
                if(hidden) {
                    iconVisible = true
                    pointDialog.width = parent.width / 10
                }
                else {
                    iconVisible = false
                    pointDialog.width = parent.width
                }
            }
        }
    }

    Controls.ToggleButton {
        id: enableToggle

        offTitle: qsTr("Disable")
        onTitle: qsTr("Enable")
        offColor: root.secondaryColor
        onColor: root.secondaryColor
        color: root.primaryColor
        active: !tempData.lockGraph

        height: pointDialog.buttonHeight
        width: parent.width - parent.width / 10

        anchors.bottom: parent.bottom
        anchors.right: pointDialog.left

        onActiveChanged: Socket.sendLock(tempData.actualChannel, "graph", !enableToggle.active)
        Component.onCompleted: tempData.graphEnable = enableToggle
    }

    Screens.LockScreen {
        active: ((!enableToggle.active) && (!connectionLock.active))
        text: qsTr("Schedule is disabled.")

        anchors.fill: graph
    }

    Screens.LockScreen {
        active: (tempData.actualChannel == -1 && (!connectionLock.active))
        text: qsTr("You haven't chosen desired room.")
    }

    Screens.LockScreen {
        id: connectionLock

        active: !root.connected
        text: qsTr("You are not connected to Dim-Box")
    }

    Screens.LockScreen {
        active: tempData.lockSchedule
        text: qsTr("Someone else is currently editing schedule.")
    }
}
