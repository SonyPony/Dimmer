import QtQuick 2.0

import "../../responsivity/responsivityLogic.js" as RL
import "../other"

Rectangle {
    id: screen

    property int particleSize: 10
    property int innerMargin: 30
    property int duration
    property var onDone
    signal hide()

    color: root.primaryColor
    width: parent.width
    height: parent.height

    LoadingAnimation {
        width: height
        height: RL.calcSize("height", 150)

        anchors.centerIn: parent
    }

    //------------------ROTATION ANIMATION------------------
    Component.onCompleted: SequentialAnimation {
        NumberAnimation { duration: 1000 }
        ScriptAction { script: {
            var component = Qt.createComponent("../other/WSClient.qml")
            root.socket = component.createObject(root)
        }}
    }
    //------------------------------------------------------

    //-------------------------HIDE-------------------------
    onHide: NumberAnimation { target: screen; property: "y"; to: screen.height; duration: 700; easing.type: Easing.InOutQuad; onRunningChanged: if(!running) screen.visible = false }
    //------------------------------------------------------
}

