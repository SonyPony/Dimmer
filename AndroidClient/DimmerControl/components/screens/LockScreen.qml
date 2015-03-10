import QtQuick 2.0

import "../../responsivity/responsivityLogic.js" as RL

Item {
    anchors.fill: parent

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    Rectangle {
        opacity: 0.8
        color: root.secondaryColor

        anchors.fill: parent
    }

    Text {
        text: "Someone else is dimming your current room."
        color: "white"

        font.family: "Trebuchet MS"
        font.pixelSize: RL.calcSize("height", 20)

        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        enabled: parent.opacity
    }
}

