import QtQuick 2.0

import "../../responsivity/responsivityLogic.js" as RL

Item {
    id: screen

    property int particleSize: RL.calcSize("height", 10)
    property int innerMargin: RL.calcSize("height", 30)
    property color color: "white"

    //----------------------OUTER PART----------------------
    Item {
        id: outerRotatingArea

        width: parent.width
        height: screen.particleSize
        anchors.centerIn: parent

        Rectangle {
            width: screen.particleSize
            height: width
            radius: width
            color: screen.color
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            width: screen.particleSize
            height: width
            radius: width
            color: screen.color
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
            color: screen.color
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            width: screen.particleSize
            height: width
            radius: width
            color: screen.color
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
    }
    //------------------------------------------------------
}

