import QtQuick 2.0
import "../../responsivity/responsivityLogic.js" as RL
import "../../logic/channelLogic.js" as CL
import "../../logic/gestures.js" as Gestures

//-------------ICON & STATUS-------------
Rectangle {
    id: panel

    property string label: ""
    property int swipeXStart
    property bool swipeDone

    onLabelChanged: roomLabel.changeText()

    Image {
        y: 10
        source: "../../resources/images/lamp.png"
        height: 70
        width: height
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        id: roomLabel

        signal changeText()

        color: "white"
        text: ""

        font.pixelSize: RL.calcSize("height", 25)
        font.family: "Trebuchet MS"

        anchors.bottom: parent.bottom
        anchors.bottomMargin: RL.calcSize("height", 30)
        anchors.horizontalCenter: parent.horizontalCenter

        onChangeText: SequentialAnimation {
            NumberAnimation { target: roomLabel; property: "opacity"; from: 1; to: 0; duration: 200 }
            ScriptAction { script: roomLabel.text = panel.label }
            NumberAnimation { target: roomLabel; property: "opacity"; from: 0; to: 1; duration: 200 }
        }
    }

    MouseArea {     //swipe area
        anchors.fill: parent
        onPressed: {
            panel.swipeDone = false
            panel.swipeXStart = mouse.x
        }
        onMouseXChanged: {
            var result = Gestures.checkSwipe(panel.swipeXStart, mouse.x, RL.calcSize("width", 250))

            if(result == "swipeRight" && (!swipeDone)) {
                CL.setPreviousRoom()
                swipeDone = true
            }

            else if(result == "swipeLeft" && (!swipeDone)) {
                CL.setNextRoom()
                swipeDone = true
            }
        }
    }

    Image {
        id: leftArrow

        source: "../../resources/images/leftArrow.png"
        width: height * (85.0 / 128.0)
        height: RL.calcSize("height", 40)

        anchors.left: parent.left
        anchors.leftMargin: RL.calcSize("width", 15)
        anchors.verticalCenter: parent.verticalCenter

        MouseArea {
            anchors.fill: parent

            onClicked: CL.setPreviousRoom()
        }
    }

    Image {
        id: rightArrow

        source: "../../resources/images/rightArrow.png"
        width: leftArrow.width
        height: leftArrow.height

        anchors.right: parent.right
        anchors.rightMargin: leftArrow.anchors.leftMargin
        anchors.top: leftArrow.top

        MouseArea {
            anchors.fill: parent

            onClicked: CL.setNextRoom()
        }
    }
}
//---------------------------------------
