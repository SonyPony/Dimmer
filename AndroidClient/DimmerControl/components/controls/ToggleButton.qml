import QtQuick 2.0

import "../other"

Item {
    property string onTitle: ""
    property string offTitle: ""
    property color onTextColor: "white"
    property color offTextColor: "white"
    property color onColor
    property color offColor
    property bool active: true
    property color color

    clip: true

    Button {
        id: onbutton

        width: parent.width
        height: parent.height
        y: (parent.active) * height

        Behavior on y {
            NumberAnimation { duration: 400; easing.type: Easing.InOutQuad }
        }

        color: onColor
        textColor: onTextColor
        title: onTitle
        onClick: (function() { parent.active = true })
    }

    Button {
        id: offbutton

        width: onbutton.width
        height: onbutton.height

        color: offColor
        textColor: offTextColor
        title: offTitle
        onClick: (function() { parent.active = false })

        anchors.bottom: onbutton.top
    }

    Triangle {
        color: parent.color
        width: height * 2
        height: offbutton.height
        inverted: true

        anchors.left: offbutton.right
        anchors.leftMargin: -offbutton.height
        anchors.bottom: parent.bottom
    }
}

