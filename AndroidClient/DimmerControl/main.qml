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

    TabView {
        id: frame
        anchors.fill: parent

        Tab {
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

            width: root.width / 3.0 + 1
            height: 7
            color: "blue"

            Behavior on x {
                NumberAnimation { easing.type: Easing.InOutQuad; duration: 400; }
            }
        }
    }
}
