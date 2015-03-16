import QtQuick 2.0

import "../../responsivity/responsivityLogic.js" as RL
import "../../logic/channelLogic.js" as CL

Rectangle {
    id: element

    property string title: "Default"
    property int pin: 0
    property var sensorAddres: 0
    property bool active: !root.channelList.lock
    property bool addAnimation: false
    property var menuWasVisible
    signal showMenu()
    signal hideMenu()

    signal remove()
    signal move()

    x: -width
    Component.onCompleted: SequentialAnimation {
        ScriptAction { script: { if(menuWasVisible) { infoPart.x = infoPart.width - identifierBox.width } }}
        NumberAnimation { target: element; property: "x"; to: 0; duration: addAnimation ?700 :0; easing.type: Easing.InOutQuad; }
    }
    //--------------------INFO PART--------------------
    Item {
        id: infoPart

        signal showMenu()
        signal hideMenu()

        width: parent.width
        height: parent.height
        //-----------------PIN IDENTIFIER------------------
        Rectangle {
            id: identifierBox

            width: height
            height: parent.height

            color: root.secondaryColor

            Text {
                text: element.pin
                color: "white"

                font.pixelSize: parent.height / 2
                font.family: "Trebuchet MS"

                anchors.centerIn: parent
            }
        }
        //-------------------------------------------------

        //----------------------TEXT-----------------------
        Item {
            width: parent.width - identifierBox.width
            height: parent.height

            anchors.left: identifierBox.right
            anchors.leftMargin: RL.calcSize("width", 15)
            anchors.topMargin: RL.calcSize("height", 10)
            anchors.top: parent.top

            Text {
                id: title

                text: element.title
                color: root.primaryColor

                font.pixelSize: RL.calcSize("height", 25)
            }

            Text {
                id: titleChannel

                text: "Pin - " + pin + "   |   Address - " + sensorAddres[0] + sensorAddres[1] + "   |   Channel - " + sensorAddres[sensorAddres.length - 1]
                color: root.lineColor

                font.pixelSize: RL.calcSize("height", 18)

                anchors.top: title.bottom
            }
        }
        //-------------------------------------------------

        onHideMenu: ParallelAnimation {
            ScriptAction { script: root.channelList.haveShownMenu[element.pin] = false }
            NumberAnimation {
                target: infoPart
                property: "x"
                to: 0
                duration: 700
                easing.type: Easing.InOutQuad
            }
        }

        onShowMenu: ParallelAnimation {
            ScriptAction { script: root.channelList.haveShownMenu[element.pin] = true }
            NumberAnimation {
                target: infoPart
                property: "x"
                to: infoPart.width - identifierBox.width
                duration: 700
                easing.type: Easing.InOutQuad
            }
        }

        MouseArea {
            id: elementMouseArea
            anchors.fill: parent
            enabled: element.active
            onClicked: (infoPart.x) ?infoPart.hideMenu() :infoPart.showMenu()
        }
    }
    //-------------------------------------------------

    //-------------------ACTION PART-------------------
    Item {
        id: actionPart

        width: parent.width - identifierBox.width
        height: parent.height

        anchors.right: infoPart.left

        Rectangle {
            id: deleteButton

            width: height
            height: parent.height
            color: root.secondaryColor

            Image {
                source: "../../resources/images/delete.png"
                antialiasing: true

                width: parent.width * 0.5
                height: width

                anchors.centerIn: parent
            }

            MouseArea {
                enabled: element.active
                anchors.fill: parent
                onClicked: {
                    root.channelList.lock = true
                    CL.popRoom(element.pin, true)
                }
            }
        }

        Rectangle {
            width: parent.width - deleteButton.width
            height: parent.height
            color: root.primaryColor

            anchors.left: deleteButton.right

            Text {
                text: "Select room"
                color: "white"

                font.family: "Trebuchet MS"
                font.pixelSize: RL.calcSize("height", 24)

                anchors.left: selectIcon.right
                anchors.leftMargin: RL.calcSize("width", 15)
                anchors.verticalCenter: parent.verticalCenter
            }

            Image {
                id: selectIcon

                source: "../../resources/images/select.png"
                antialiasing: true

                width: height
                height: parent.height / 3

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: RL.calcSize("width", 50)
            }

            MouseArea {
                anchors.fill: parent
                enabled: element.active
                onClicked: {
                    CL.setChannel(element.pin, element.title, sensorAddres[0] + sensorAddres[1], sensorAddres[sensorAddres.length - 1])
                    frame.currentIndex = 0;
                    infoPart.hideMenu()
                }
            }
        }
    }
    //-------------------------------------------------

    onMove: NumberAnimation { target: element; property: "y"; to: y - height; duration: 400; easing.type: Easing.InOutQuad }
    onRemove: SequentialAnimation {
        ScriptAction { script: {element.move()} }
        NumberAnimation { duration: 400 }  //delay
        ScriptAction {
            script: {
                var key = CL.getRoomIndexFromPin(element.pin)

                root.channelList.lock = false
                root.channelList.haveShownMenu[element.pin] = false

                tempData.pinList.push(tempData.channels[key]["pin"])
                tempData.pinList.sort(function(a,b) { return a - b; })
                tempData.pinListChanged()

                tempData.channels.splice(key, 1)
                tempData.channelsChanged()
            }
        }
    }
}
