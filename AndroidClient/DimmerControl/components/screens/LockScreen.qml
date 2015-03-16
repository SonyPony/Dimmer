import QtQuick 2.0

import "../../responsivity/responsivityLogic.js" as RL

PopUpScreen {
    property alias text: info.text

    Text {
        id: info

        color: "white"
        wrapMode: TextEdit.WordWrap

        width: parent.width * 3/5
        horizontalAlignment: Text.AlignHCenter

        font.family: "Trebuchet MS"
        font.pixelSize: RL.calcSize("height", 30)

        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        enabled: parent.opacity
    }
}

