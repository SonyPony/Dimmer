import QtQuick 2.0

Item {
    property bool active

    opacity: active
    anchors.fill: parent

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    Rectangle {
        opacity: 0.8
        color: root.secondaryColor

        anchors.fill: parent
    }
}

