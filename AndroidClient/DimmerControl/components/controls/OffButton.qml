import QtQuick 2.0
import "../../responsivity/responsivityLogic.js" as RL

Item {
    id: powerButton

    property bool active: true

    Image {
        id: offButton

        source: "../../resources/images/powerOff.png"
        width: parent.width//256 /2//RL.calcSize("width", 140)
        height: parent.height//265 / 2//300
    }

    Image {
        id: onButton

        source: "../../resources/images/powerOn.png"
        opacity: (powerButton.active) ?1 :0

        width: parent.width//256 /2//RL.calcSize("width", 140)
        height: parent.height//265 / 2//300

        Behavior on opacity {
            NumberAnimation { easing.type: Easing.InOutCubic; duration: 1000;  }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: powerButton.active = (powerButton.active) ?false :true
    }
}
