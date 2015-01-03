import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.1
import QtQuick.Controls.Styles 1.2

import "components/controls" as Controls
import "components/tabs" as Tabs

ApplicationWindow {
    id: root

    visible: true
    width: 480
    height: 854
    title: qsTr("Hello World")

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

    TabView {
        id: frame
        anchors.fill: parent

        Tab {
        width: parent.width
        height: RL.calcSize("height", 700)
        anchors.bottom: positioner.bottom

            title: "Tab 1"

            Tabs.DimmerTab {}
        }

        Tab {
            title: "Tab 2"

            Tabs.ProgramTab {}
        }
        Tab { title: "Tab 3" }

        //---------------TAB STYLE---------------
        style: TabViewStyle {
            frameOverlap: 1
            frame: Rectangle { color: "white" }
            tab: Rectangle {        //tab style
                property bool selected: styleData.selected

                color: "#76C012"

                implicitWidth: root.width / 3.0 + 1
                implicitHeight: 60

                Text {
                    id: text
                    anchors.centerIn: parent
                    text: styleData.title
                    color: styleData.selected ? "white" : "black"
                }

                onSelectedChanged: {
                    if(styleData.selected)
                        slideBar.x = styleData.index * (root.width / 3.0 + 1)

                }
            }
        }
        //---------------------------------------

        Rectangle {     //rect beneath the tab -> define selected tab
            id: slideBar
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
