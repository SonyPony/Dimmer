import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Dialogs 1.2
import Qt.WebSockets 1.0
import FileStream 1.0

import "components/controls" as Controls
import "components/tabs" as Tabs
import "components/other"
import "components/screens" as Screens
import "components/panels" as Panels
import "components/dialogs" as Dialogs
import "responsivity/responsivityLogic.js" as RL
import "logic/channelLogic.js" as CL
import "logic/messageController.js" as Socket

ApplicationWindow {
    id: root

    property color primaryColor: "#00C0FF"
    property color secondaryColor: "#232020"
    property color ternaryColor: "#333333"
    property color lineColor: "lightGray"
    property color cancelColor: "#FE2126"

    property real illuminance: 0
    property real tabCount: 5.0
    property var tabIcons: ["resources/images/dim.png", "resources/images/program.png", "resources/images/channel.png", "resources/images/settings.png", "resources/images/help.png"]
    property var tabLabels: [qsTr("Dim"), qsTr("Schedule"), qsTr("Channel"), qsTr("Settings"), qsTr("Help")]
    property var socket
    property var slider
    property bool lock: false
    property bool connected: false
    property var channelList
    property string language: Qt.locale().name.substring(0,2)

    QtObject {
        id: tempData

        property bool lockSchedule: false
        property bool lockDim: false
        property bool lockGraph: false
        property var graphEnable
        property int actualSensorChannel: 0

        property int actualChannel: -1  //store pin
        property var channels: []
        property var graph

        property var pinList: []
        property var adressList: [0, 1, 2, 3, 4, 5, 6, 7]

        onActualChannelChanged: {
            for(var key in graph.internal.points)
                graph.removePoint(Math.floor(key / 100), key % 100)

            if(actualChannel != -1) {
                Socket.requestDim()
                Socket.requestAllSchedulePoints(actualChannel)
                last_channel.write(actualChannel)
            }
        }
        onChannelsChanged: {
            if(!channels.length)
                CL.setNoneRoom()
            else
                CL.autoSelectChannel(last_channel)
        }

        onLockDimChanged: {
            if(!lockDim)
                Socket.requestDim()
        }
    }

    visible: true
    width: 480
    height: 782
    title: qsTr("Dim-Box")

    Item {
        id: positioner
        anchors.fill: parent
    }

    FileStream {
        id: fileStream

        source: "config.txt"
    }

    FileStream {
        id: last_channel

        source: "temp.txt"
    }

    //-------------ERROR DIALOG--------------
    Dialogs.PopUpDialog {
        id: errorDialog

        z: 7
        title: qsTr("Error")
        color: "#ffbb00"
        backgroundColor: root.secondaryColor

        function error(message) {
            errorDialog.text = message
            errorDialog.show()
        }
    }
    //---------------------------------------

    //-------------ICON & STATUS-------------
    Panels.InfoPanel {
        id: infoPanel

        width: root.width
        height: root.height - frame.height

        color: root.secondaryColor
    }
    //---------------------------------------

    //---------------TAB VIEW----------------
    TabView {
        id: frame

        width: parent.width
        height: RL.calcSize("height", 700)
        anchors.bottom: positioner.bottom

        Tab {   //tab with slider
            id: dimmerTab

            Tabs.DimmerTab {
            }
        }

        Tab {   //tab width graph
            id: scheduleTab
            active: true

            Tabs.ScheduleTab {}
        }

        Tab {   //channel
            id: channelTab
            active: true

            Tabs.ChannelTab {

            }
        }

        Tab {   //settings

            Tabs.SettingsTab {

            }
        }

        Tab {
            Tabs.HelpTab {}
        }

        //---------------------------------------TAB VIEW

        //---------------TAB STYLE---------------
        style: TabViewStyle {
            frameOverlap: 1
            frame: Rectangle { color: "white" }
            tab: Rectangle {        //tab style
                property bool selected: styleData.selected

                color: root.primaryColor

                implicitWidth: Math.round(root.width / root.tabCount) + 1
                implicitHeight: RL.calcSize("height", 100)

                Image {
                    id: image

                    source: root.tabIcons[styleData.index]
                    opacity: (parent.selected) ?1 : 0.5

                    Behavior on opacity {
                        NumberAnimation { duration: 700 }
                    }

                    width: Math.min(parent.implicitWidth, parent.implicitHeight) * 0.5
                    height: width

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: RL.calcSize("height", 20)
                }

                Text {
                    id: label

                    text: root.tabLabels[styleData.index]
                    color: "white"
                    opacity: (parent.selected) ?1 : 0.5

                    Behavior on opacity {
                        NumberAnimation { duration: 700 }
                    }

                    font.family: "trebuchet MS"
                    font.pixelSize: RL.calcSize("height", 14)

                    anchors.top: image.bottom
                    anchors.topMargin: RL.calcSize("height", 4)
                    anchors.horizontalCenter: image.horizontalCenter
                }

                onSelectedChanged: {
                    if(styleData.selected)
                        slideBar.x = styleData.index * (root.width / root.tabCount + 1)
                }

            }
        }
        //---------------------------------------STYLE
    }

    Rectangle {
        id: connectionStatus

        width: RL.calcSize("width", 60)
        height: RL.calcSize("height", 6)
        radius: height

        color: (root.connected) ?root.primaryColor :root.cancelColor

        Behavior on color {
            ColorAnimation { duration: 1000 }
        }

        anchors.bottom: slideBar.top
        anchors.bottomMargin: RL.calcSize("height", 15)
        anchors.horizontalCenter: positioner.horizontalCenter
    }

    //--------------TAB POINTER--------------
    Item {     //define selected tab
        id: slideBar

        width: frame.width / root.tabCount + 1
        anchors.top: frame.top  //stick to tab view

        Behavior on x {
            NumberAnimation { easing.type: Easing.InOutQuad; duration: 400; }
        }

        Triangle {
            width: RL.calcSize("width", 27)
            height: RL.calcSize("height", 14)
            color: root.secondaryColor

            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    //---------------------------------------TAB POINTER

    Screens.LoadingScreen {
        id: loadingScreen
    }

    Timer {
        id: channelDeleteManager

        signal done()
        property int counter: 0
        property var listOfDeleting: new Array
        property var synchronizationScreen

        repeat: true
        interval: 450
        triggeredOnStart: true
        running: false

        onRunningChanged: {
            if(!running) {
                listOfDeleting = new Array
                done()
            }
            else {
                Socket.requestAllPins()
                counter = 0
                synchronizationScreen.active = true
            }
        }
        onTriggered: {
            if(counter >= listOfDeleting.length)
                channelDeleteManager.running = false
            else
                CL.popRoom(listOfDeleting[counter], false)
            counter++

        }

        onDone: {
            if(root.socket.status == WebSocket.Open)
                Socket.requestAllChannels()
            synchronizationScreen.active = false
        }
    }
}

