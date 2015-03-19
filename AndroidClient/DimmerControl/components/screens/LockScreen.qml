import QtQuick 2.0

import "../../responsivity/responsivityLogic.js" as RL

PopUpScreen {
    property alias text: info.text

    Item {
        width: parent.width * 3/5
        anchors.centerIn: parent

        Text {
            id: info

            color: "white"
            wrapMode: TextEdit.WordWrap
            width: parent.width
            horizontalAlignment: Text.AlignHCenter

            font.family: "Trebuchet MS"
            font.pixelSize: RL.calcSize("height", 30)

            anchors.horizontalCenter: parent.horizontalCenter
        }

        Image {
            id: logo

            source: "../../resources/images/logo.png"
            width: height * 403/510
            height: RL.calcSize("height", 150)

            anchors.bottom: info.top
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: parent.opacity
    }
}

