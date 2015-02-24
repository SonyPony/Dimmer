import QtQuick 2.0
import "../../responsivity/responsivityLogic.js" as RL

//-------------ICON & STATUS-------------
Rectangle {
    id: status

    width: root.width
    height: root.height - frame.height

    color: root.secondaryColor

    Text {
        id: roomLabel

        color: "white"
        text: ""

        font.pixelSize: RL.calcSize("height", 25)
        font.family: "Trebuchet MS"

        anchors.bottom: parent.bottom
        anchors.bottomMargin: RL.calcSize("height", 30)
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Image {
        id: leftArrow

        source: "resources/images/leftArrow.png"
        width: 30
        height: 30
    }

    Image {
        id: rightArrow

        source: "resources/images/rightArrow.png"
        width: 30
        height: 30

        anchors.right: parent.right
    }

    Image {
        source: "resources/images/bulbOutline.png"
        rotation: 180

        y: -RL.calcSize("height", 10)
        width: RL.calcSize("height", 80)
        height: width

        anchors.horizontalCenter: parent.horizontalCenter

        Image {
            id: dimmingBulb

            source: "resources/images/bulbInner.png"
            opacity: 0
            anchors.fill: parent
        }
    }
}
//---------------------------------------
