import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import "../../responsivity/responsivityLogic.js" as RL

Switch {
    id: switchControl

    style: SwitchStyle {
        groove: Rectangle {
            id: grooveRect

            implicitWidth: switchControl.width//RL.calcSize("width", 100)
            implicitHeight: switchControl.height//implicitWidth / 3.5

            radius: 1
            color: control.checked ? "#76C012" : "lightGray"
        }

        handle: Rectangle {
            implicitWidth: switchControl.width / 2//grooveRect.implicitWidth / 2
            implicitHeight: switchControl.height//grooveRect.implicitHeight

            color: "white"
            radius: 2

            border.color: "gray"
            border.width: 1
        }
    }
}

