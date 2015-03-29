import QtQuick 2.0

import "../../responsivity/responsivityLogic.js" as RL

Rectangle {
    id: button

    property var onClick
    property string title: ""
    property color textColor: "white"
    property string iconSource: ""
    property bool iconVisible: false

    color: root.primaryColor

    Text {
        text: button.title
        color: button.textColor
        opacity: !iconVisible

        font.family: "Verdana"
        font.pixelSize: RL.calcSize("height", 30)

        anchors.centerIn: parent

        Behavior on opacity {
            NumberAnimation { duration: 400 }
        }
    }

    Image {
        source: ((button.iconSource) ?"../../" + button.iconSource :"")
        width: height
        height: parent.height * 0.7
        opacity: iconVisible

        anchors.centerIn: parent

        Behavior on opacity {
            NumberAnimation { duration: 400 }
        }
    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            button.onClick()
        }
    }
}

