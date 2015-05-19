import QtQuick 2.0

import "../controls" as Controls
import "../../responsivity/responsivityLogic.js" as RL

Rectangle {
    Controls.TextInput {     //IP input
        id: ipInput

        validator: RegExpValidator { regExp: /\d\d?\d?\.\d\d?\d?\.\d\d?\d?\.\d\d?\d?/ }
        placeholderText: qsTr("IP address")

        width: RL.calcSize("width", 300)
        height: RL.calcSize("height", 60)

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: RL.calcSize("width", 10)
        anchors.topMargin: RL.calcSize("height", 40)
    }

    Controls.TextInput {     //IP input
        id: portInput

        text: "8888"
        validator: RegExpValidator { regExp: /\d\d\d\d/ }
        placeholderText: qsTr("Port")

        width: RL.calcSize("width", 120)
        height: RL.calcSize("height", 60)

        anchors.top: ipInput.top
        anchors.left: colonText.right
        anchors.leftMargin: RL.calcSize("width", 10)
    }

    Text {      //colon
        id: colonText

        text: ":"
        color: root.secondaryColor

        font.family: "Trebuchet MS"
        font.pixelSize: RL.calcSize("height", 50)

        anchors.leftMargin: RL.calcSize("width", 10)
        anchors.left: ipInput.right
        anchors.bottom: ipInput.bottom
    }

    Controls.Button {
        width: parent.width
        height: RL.calcSize("height", 60)
        title: qsTr("Apply")

        anchors.bottom: parent.bottom

        onClick: function() {
            root.socket.url = 'ws://' + ipInput.text + ':' + portInput.text
            fileStream.write(root.socket.url)
            console.log(root.socket.url)
            root.socket.reconnect()
        }
    }
}

