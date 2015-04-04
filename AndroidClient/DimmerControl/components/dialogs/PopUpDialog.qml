import QtQuick 2.0

import "../../responsivity/responsivityLogic.js" as RL
import "../screens"

Item {
    id: dialog

    property string title: ""
    property string text: ""
    property color color
    property color backgroundColor

    signal show()
    signal hide()

    onShow: opacity = 1
    onHide: opacity = 0

    visible: opacity
    opacity: 0
    anchors.fill: parent

    Behavior on opacity {
        NumberAnimation { duration: 400 }
    }

    //--------------MASK--------------
    PopUpScreen {
        active: parent.visible
    }
    //--------------------------------

    //-----------BLOCK EVENT----------
    MouseArea {
        enabled: parent.visible
        anchors.fill: parent
    }
    //--------------------------------

    //------------CONTENT-------------
    Rectangle {
        width: parent.width
        height: RL.calcSize("height", 175)
        color: dialog.backgroundColor

        anchors.verticalCenter: parent.verticalCenter

        //-------------TITLE--------------
        Text {
            id: title

            text: dialog.title
            color: dialog.color

            font.family: "Trebuchet MS"
            font.pixelSize: RL.calcSize("height", 35)

            anchors.topMargin: RL.calcSize("height", 20)
            anchors.leftMargin: RL.calcSize("width", 15)
            anchors.top: parent.top
            anchors.left: parent.left
        }
        //--------------------------------

        //------------INFO TEXT-----------
        Text {
            text: dialog.text
            wrapMode: TextEdit.WordWrap
            color: "white"
            width: parent.width

            font.family: "Trebuchet MS"
            font.pixelSize: RL.calcSize("height", 25)

            anchors.left: title.left
            anchors.topMargin: RL.calcSize("height", 10)
            anchors.top: title.bottom
        }
        //--------------------------------

        //-----------OK BUTTON------------
        Rectangle {
            width: RL.calcSize("width", 150)
            height: RL.calcSize("height", 45)

            color: title.color

            anchors.bottomMargin: RL.calcSize("height", 10)
            anchors.rightMargin: RL.calcSize("width", 15)
            anchors.bottom: parent.bottom
            anchors.right: parent.right

            Text {
                text: "Ok"
                color: "white"

                font.family: "Trebuchet MS"
                font.pixelSize: RL.calcSize("height", 25)

                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                enabled: dialog.visible
                onClicked: dialog.hide()
            }
        }
        //--------------------------------
    }
    //--------------------------------
}

