import QtQuick 2.0
import "../other"
import "../../responsivity/responsivityLogic.js" as RL

PopUpScreen {
    id: screen

    signal start()

    LoadingAnimation {
        width: height
        height: RL.calcSize("height", 150)

        color: "white"

        anchors.centerIn: parent
    }
}

