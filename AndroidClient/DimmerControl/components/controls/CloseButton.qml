import QtQuick 2.0

import "../../responsivity/responsivityLogic.js" as RL

Rectangle {
    signal close

    color: "#FE2126"

    Rectangle {
        height: parent.width * 0.08
        width: parent.width * 0.85

        rotation: 45
        color: "white"

        anchors.centerIn: parent
    }

    Rectangle {
        height: parent.width * 0.08
        width: parent.width * 0.85

        rotation: -45
        color: "white"

        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent

        onClicked: parent.close()
    }
}
