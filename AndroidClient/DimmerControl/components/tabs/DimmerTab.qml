import QtQuick 2.0
import "../controls" as Controls

Rectangle {
    Controls.Slider {
         width: parent.width
         height: parent.height

         color: "lightGray"
         activeColor: "orange"
         toggleColor: "gray"
         lineWidth:  5
         toggleSize: 20
         minimum: 0
         maximum: 100
     }
}
