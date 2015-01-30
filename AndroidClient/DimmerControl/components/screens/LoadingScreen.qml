import QtQuick 2.0

import "../../responsivity/responsivityLogic.js" as RL

Rectangle {
    id: screen

    property int particleSize: 10
    property int innerMargin: 30
    signal hide()

    color: root.primaryColor

    //----------------------OUTER PART----------------------
    Item {
        id: outerRotatingArea

        width: RL.calcSize("height", 150)
        height: screen.particleSize
        anchors.centerIn: parent

        Rectangle {
            width: screen.particleSize
            height: width
            radius: width
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            width: screen.particleSize
            height: width
            radius: width
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    //------------------------------------------------------

    //----------------------INNER PART----------------------
    Item {
        id: innerRotatingArea

        width: outerRotatingArea.width * (2.0/3.0)
        height: screen.particleSize
        anchors.centerIn: outerRotatingArea

        Rectangle {
            width: screen.particleSize
            height: width
            radius: width
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            width: screen.particleSize
            height: width
            radius: width
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    //------------------------------------------------------

    //------------------ROTATION ANIMATION------------------
    Component.onCompleted: ParallelAnimation {
        RotationAnimation {
            target: innerRotatingArea
            property: "rotation"
            from: 0
            to: 360
            loops: Animation.Infinite
            duration: 1000
        }

        RotationAnimation {
            target: outerRotatingArea
            property: "rotation"
            from: 360
            to: 0
            loops: Animation.Infinite
            direction: RotationAnimation.Counterclockwise
            duration: 4000
        }

        SequentialAnimation {
            NumberAnimation { duration: 1000 }
            ScriptAction { script: {
                var component = Qt.createComponent("../other/WSClient.qml")
                root.socket = component.createObject(root)
            }}
        }
    }
    //------------------------------------------------------

    //-------------------------HIDE-------------------------
    onHide: NumberAnimation { target: screen; property: "y"; to: screen.height; duration: 700; easing.type: Easing.InOutQuad }
    //------------------------------------------------------
}

