import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.1
import QtQuick.Controls.Styles 1.2

import "components/controls" as Controls
import "components/tabs" as Tabs
import "components/other"
import "responsivity/responsivityLogic.js" as RL

ApplicationWindow {
    id: root

    property real tabCount: 4.0

    visible: true
    width: 480
    height: 854
    title: qsTr("Ultra Dimmer")

    Item {
        id: positioner
        anchors.fill: parent
    }

    //-------------ICON & STATUS-------------
    Rectangle {
        id: status

        width: root.width
        height: root.height - frame.height

        color: "#404040"
    }

    //---------------------------------------

    //---------------TAB VIEW----------------
    TabView {
        id: frame

        width: parent.width
        height: RL.calcSize("height", 700)
        anchors.bottom: positioner.bottom

        Tab {   //tab with slider
            title: "Tab 1"

            Tabs.DimmerTab {}
        }

        Tab {   //tab width graph
            title: "Tab 2"

            Tabs.ScheduleTab {}
        }

        Tab {   //luminosity
            title: "Tab 3"
        }

        Tab {   //channel
            title: "Tab 4"
        }

        //---------------TAB STYLE---------------
        style: TabViewStyle {
            frameOverlap: 1
            frame: Rectangle { color: "white" }
            tab: Rectangle {        //tab style
                property bool selected: styleData.selected

                color: "#76C012"

                implicitWidth: root.width / root.tabCount + 1
                implicitHeight: RL.calcSize("height", 70)

                Text {
                    id: text
                    anchors.centerIn: parent
                    text: styleData.title
                    color: styleData.selected ? "white" : "black"
                }

                onSelectedChanged: {
                    if(styleData.selected)
                        slideBar.x = styleData.index * (root.width / root.tabCount + 1)

                }
            }
        }
        //---------------------------------------STYLE
    }
    //---------------------------------------TAB VIEW

    //--------------TAB POINTER--------------
    Item {     //define selected tab
        id: slideBar

        width: frame.width / root.tabCount + 1
        anchors.top: frame.top  //stick to tab view

        Behavior on x {
            NumberAnimation { easing.type: Easing.InOutQuad; duration: 400; }
        }

        Triangle {
            width: 40
            height: 15
            color: "#404040"

            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    //---------------------------------------TAB POINTER
}

