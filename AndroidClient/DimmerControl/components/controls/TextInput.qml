import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import "../../responsivity/responsivityLogic.js" as RL

TextField {
    id: input

    property string title: ""
    horizontalAlignment: TextInput.AlignRight

    style: TextFieldStyle {
        background: Rectangle {
            color: "transparent"
            radius: RL.calcSize("height", 5)

            border.width: RL.calcSize("height", 3)
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

