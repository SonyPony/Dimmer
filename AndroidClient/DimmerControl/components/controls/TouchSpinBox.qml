import QtQuick 2.0
import "../../responsivity/responsivityLogic.js" as RL

Item {
    id: spinbox

    property int minimum
    property int step
    property int count
    property color edgeColor
    property color textColor
    property string title
    property int value: Math.round(flick.contentY / height) * step + minimum

    Flickable {
        id: flick

        clip: true
        boundsBehavior: Flickable.StopAtBounds

        width: parent.width
        height: parent.height

        contentWidth: width
        contentHeight: parent.count * height

        onMovementEnded: NumberAnimation {
            target: flick;
            property: "contentY";
            to: Math.round(flick.contentY / spinbox.height) * spinbox.height;
            duration: 400
        }

        Column {
            Repeater {
                model: spinbox.count
                delegate: Item {
                    width: spinbox.width
                    height: spinbox.height

                    Text {
                        text: modelData * spinbox.step + spinbox.minimum
                        color: spinbox.textColor

                        font.family: "Trebuchet MS"
                        font.pixelSize: RL.calcSize("height", 30)

                        anchors.centerIn: parent
                    }
                }
            }
        }
    }

    Text {
        text: parent.title

        color: parent.textColor
        opacity: (flick.moving) ?0 :1

        font.family: "Trebuchet MS"
        font.pixelSize: RL.calcSize("height", 20)

        anchors.bottom: topLine.top
        anchors.horizontalCenter: parent.horizontalCenter

        Behavior on opacity {
            NumberAnimation { duration: 250 }
        }
    }

    Rectangle {
        id: topLine

        width: parent.width
        height: RL.calcSize("height", 3)

        color: parent.edgeColor

        anchors.topMargin: RL.calcSize("height", 20)
        anchors.top: parent.top
    }

    Rectangle {
        width: parent.width
        height: RL.calcSize("height", 3)

        color: parent.edgeColor

        anchors.bottomMargin: RL.calcSize("height", 20)
        anchors.bottom: parent.bottom
    }
}
