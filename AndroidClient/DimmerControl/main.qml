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
import "responsivity/responsivityLogic.js" as RL
import "logic/channelLogic.js" as CL

ApplicationWindow {
    id: root

    property color primaryColor: "#00C0FF"
    property color secondaryColor: "#232020"
    property color ternaryColor: "#333333"
    property color lineColor: "lightGray"
    property color cancelColor: "#FE2126"

    property real luminosity: 0
    property real tabCount: 5.0
    property var tabIcons: ["resources/images/dim.png", "resources/images/program.png", "resources/images/channel.png", "resources/images/settings.png", "resources/images/help.png"]
    property var tabLabels: ["Dim", "Schedule", "Channel", "Settings", "Help"]
    property var socket
    property var slider
    property bool lock: false
    property string language: Qt.locale().name.substring(0,2)

    onLockChanged: {
        if(!lock)
            Socket.requestDim()
    }


    QtObject {
        id: tempData

        property int actualSensorAddress: 0
        property int actualSensorChannel: 0

        property int actualChannel  //store pin
        property var channels: new Array
        onActualChannelChanged: Socket.requestDim()
    }

    visible: true
    width: 480
    height: 782
    title: qsTr("Ultra Dimmer")

    Item {
        id: positioner
        anchors.fill: parent
    }

    FileStream {
        id: fileStream

        source: "config.txt"
    }

    //-------------ERROR DIALOG--------------
    MessageDialog {
        id: errorDialog

        title: "Error"

        function error(message) {
            errorDialog.text = message
            errorDialog.visible = true
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

            title: "Dim"

            Tabs.DimmerTab {
            }
        }

        Tab {   //tab width graph
            id: scheduleTab
            title: "Schedule"

            Tabs.ScheduleTab {}
        }

        Tab {   //channel
            title: "Channel"
            id: channelTab

            Tabs.ChannelTab {

            }
        }

        Tab {   //settings
            title: "Settings"

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

        color: root.cancelColor

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

        width: root.width
        height: root.height
    }
}

