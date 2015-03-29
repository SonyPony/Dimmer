import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import "../../responsivity/responsivityLogic.js" as RL

TextField {
    id: input

    property string title: ""
    horizontalAlignment: TextInput.AlignRight
    inputMethodHints: Qt.ImhSensitiveData

    style: TextFieldStyle {
        background: Rectangle {
            color: "transparent"

            border.width: RL.calcSize("height", 2)
            border.color: root.primaryColor
        }

        textColor: root.secondaryColor
        font.family: "Trebuchet MS"
        font.pixelSize: input.height * 0.7
    }

    //ADDITIONAL TEXT
    Text {      //Title input
        text: input.title
        color: root.secondaryColor

        font.family: "Trebuchet MS"
        font.pixelSize: RL.calcSize("height", 20)

        anchors.bottom: input.top
        anchors.horizontalCenter: input.horizontalCenter
    }
}

