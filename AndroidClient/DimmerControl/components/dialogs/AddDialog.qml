import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import "../controls" as Controls
import "../../responsivity/responsivityLogic.js" as RL

Item {
    id: dialog

    property int buttonHeight: RL.calcSize("height", 60)
    property var acceptFunction
    property alias content: content
    property bool hidden: (content.y == addButton.y) ?true :false

    Item {  //content
        id: content

        y: addButton.y
        width: parent.width
        height: parent.height - addButton.height

        Behavior on y {
            NumberAnimation { easing.type: Easing.InOutQuad; duration: 500 }
        }

        Rectangle { //background
            color: "#EEEEEE"
            opacity: 0.7

            anchors.fill: parent
        }

        Controls.CloseButton {
            width: RL.calcSize("height", 30)
            height: width

            anchors.right: parent.right

            onClose: parent.y = addButton.y
        }
    }

    Controls.Button {
        id: addButton

        width: parent.width
        height: parent.buttonHeight
        title: qsTr("Add")

        anchors.bottom: parent.bottom

        onClick: function() {
            if(content.y != addButton.y)  // not hidden
                acceptFunction()
            content.y = (content.y == addButton.y) ?addButton.y - content.height :addButton.y
        }
    }
}
