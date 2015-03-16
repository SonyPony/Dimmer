import QtQuick 2.0

import "../other"
import "../../responsivity/responsivityLogic.js" as RL
import "../../logic/channelLogic.js" as CL
import "../dialogs" as Dialogs

Item {
    id: channelListView

    //property var channels: []
    //onChannelsChanged: tempData.channels = channels

    Flickable {
        id: flick

        clip: true
        boundsBehavior: Flickable.StopAtBounds

        width: parent.width
        height: parent.height - roomDialog.buttonHeight

        contentWidth: width
        contentHeight: tempData.channels.length * RL.calcSize("height", 80)

        Column {
            Repeater {
                id: repeater

                property int newItemIndex: -1
                property var lines: new Array
                property var haveShownMenu: new Array

                Component.onCompleted: root.channelList = repeater

                model: tempData.channels
                delegate: Item {
                    property alias singleElement: singleElement

                    z: repeater.count - singleElement.index
                    width: channelListView.width
                    height: RL.calcSize("height", 80)

                    ChannelListElement {
                        id: singleElement

                        property int index: CL.getRoomIndexFromPin(modelData[1])

                        pin: modelData[1]
                        sensorAddres: modelData[2]
                        title: modelData[0]
                        addAnimation: (repeater.newItemIndex == pin) ?true :false
                        menuWasVisible: repeater.haveShownMenu[pin]

                        width: channelListView.width
                        height: RL.calcSize("height", 78)

                        onShowMenu: {
                            (index) ?repeater.lines[index - 1].width = parent.width :0
                            repeater.lines[index].width = parent.width
                        }

                        onHideMenu: {
                            (index) ?repeater.lines[index - 1].width = parent.width - RL.calcSize("width", 15) :0
                            repeater.lines[index].width = parent.width - RL.calcSize("width", 15)
                        }
                    }

                    Rectangle {     //line below
                        id: bottomLine

                        height: 2
                        color: root.lineColor
                        anchors.top: singleElement.bottom

                        Behavior on width {
                            NumberAnimation { duration: 700; easing.type: Easing.InOutQuad }
                        }

                        Component.onCompleted: ParallelAnimation {
                            ScriptAction { script: repeater.lines[singleElement.index] = bottomLine  }
                            NumberAnimation {
                                target: bottomLine;
                                property: "width";
                                to: singleElement.width - RL.calcSize("width", 15);
                                duration: (repeater.newItemIndex == singleElement.pin) ?700 :0;
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                }
            }
        }
    }

    Dialogs.RoomDialog {
        id: roomDialog

        width: parent.width
        height: RL.calcSize("height", 210)
        buttonHeight: RL.calcSize("height", 60)

        anchors.bottom: parent.bottom
    }
}
