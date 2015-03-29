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
    property int delay: 0
    property bool hidden: true
    property alias iconVisible: addButton.iconVisible
    property bool active: true

    signal showContent()
    signal hideContent()

    onShowContent: content.show()
    onHideContent: content.hide()

    clip: true

    Item {  //content
        id: content

        signal hide()
        signal show()

        y: addButton.y
        width: parent.width
        height: parent.height - addButton.height

        onShow: SequentialAnimation {
            ScriptAction { script: {hidden = false} }
            NumberAnimation { duration: delay }
            NumberAnimation { target: content; property: "y"; to:addButton.y - content.height; easing.type: Easing.InOutQuad; duration: 500 }
        }

        onHide: SequentialAnimation {
            NumberAnimation { target: content; property: "y"; to:addButton.y; easing.type: Easing.InOutQuad; duration: 500 }
            NumberAnimation { duration: delay }
            ScriptAction { script: hidden = true }
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

            onClose: content.hide()
        }
    }

    Controls.Button {
        id: addButton

        width: parent.width
        height: parent.buttonHeight
        title: qsTr("Add")
        iconSource: "resources/images/plus.png"

        anchors.bottom: parent.bottom

        onClick: function() {
            if(!hidden) { // not hidden
                acceptFunction()
                content.hide()
            }

            else {
                if(dialog.active)
                    content.show()
            }
        }
    }
}
