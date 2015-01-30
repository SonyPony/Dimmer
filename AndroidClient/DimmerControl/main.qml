import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Dialogs 1.2
import Qt.WebSockets 1.0

import "components/controls" as Controls
import "components/tabs" as Tabs
import "components/other"
import "responsivity/responsivityLogic.js" as RL

ApplicationWindow {
    id: root

    property color primaryColor: "#00C0FF"
    property color secondaryColor: "#232020"
    property color ternaryColor: "#333333"
    property color lineColor: "lightGray"
    property color cancelColor: "#FE2126"

    property real tabCount: 4.0
    property var tabIcons: ["resources/images/Sun.png", "resources/images/Sun.png", "resources/images/Sun.png", "resources/images/wheel.png"]
    property var tabIcons: ["resources/images/dim.png", "resources/images/program.png", "resources/images/channel.png", "resources/images/settings.png"]
    property var tabLabels: ["Dim", "Schedule", "Channel", "Settings"]

    visible: true
    width: 480
    height: 782
    title: qsTr("Ultra Dimmer")

    Item {
        id: positioner
        anchors.fill: parent
    }

    WebSocket {
        id: socket

        active: true
        url: "ws://169.254.29.212:8888"

        onStatusChanged: {
            var actualStatus = socket.status

            switch(actualStatus) {
                case WebSocket.Connecting:
                    console.log("Connecting");
                    break;

                case WebSocket.Open:
                    connectionStatus.color = "#76C012"
                    console.log("Open");
                    break;

                case WebSocket.Closing:
                    console.log("Closing");
                    break;

                case WebSocket.Closed:
                    connectionStatus.color = "orange"
                    console.log("Closed");
                    break;

                case WebSocket.Error:
                    connectionStatus.color = "orange"
                    console.log("Error (" + socket.errorString + ")")
                    break;
            }
        }
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
    Rectangle {
        id: status

        width: root.width
        height: root.height - frame.height

        color: root.secondaryColor

        Image {
            source: "resources/images/bulbOutline.png"
            rotation: 180

            y: -RL.calcSize("height", 10)
            width: RL.calcSize("height", 80)
            height: width

            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: dimmingBulb

                source: "resources/images/bulbInner.png"
                opacity: 0
                anchors.fill: parent
            }
        }
    }

    //---------------------------------------

    //---------------TAB VIEW----------------
    TabView {
        id: frame

        width: parent.width
        height: RL.calcSize("height", 700)
        anchors.bottom: positioner.bottom

        Tab {   //tab with slider
            title: "Dim"

            Tabs.DimmerTab {}
        }

        Tab {   //tab width graph
            id: sheduleTab
            title: "Schedule"

            Tabs.ScheduleTab {}
        }

        Tab {   //luminosity
            title: "Tab 3"

        }

        Tab {   //channel
            title: "Tab 4"
        }
        //---------------------------------------TAB VIEW

        //---------------TAB STYLE---------------
        style: TabViewStyle {
            frameOverlap: 1
            frame: Rectangle { color: "white" }
            tab: Rectangle {        //tab style
                property bool selected: styleData.selected

                color: root.primaryColor

                implicitWidth: root.width / root.tabCount + 1
                implicitHeight: RL.calcSize("height", 100)


                Image {
                    source: root.tabIcons[styleData.index]

                    width: Math.min(parent.implicitWidth, parent.implicitHeight)
                    height: width

                    anchors.centerIn: parent
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
            width: RL.calcSize("width", 40)
            height: RL.calcSize("height", 15)
            color: "#404040"

            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    //---------------------------------------TAB POINTER
}

