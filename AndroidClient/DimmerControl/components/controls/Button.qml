import QtQuick 2.0

import "../../responsivity/responsivityLogic.js" as RL

Rectangle {
    id: button

    property var onClick
    property string title: ""

    color: root.primaryColor

    Text {
        text: button.title
        color: "white"

        font.family: "Verdana"
        font.pixelSize: RL.calcSize("height", 30)

        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            button.onClick()
        }
    }
}

