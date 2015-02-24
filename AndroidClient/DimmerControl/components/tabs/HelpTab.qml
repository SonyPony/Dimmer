import QtQuick 2.0
import "../../responsivity/responsivityLogic.js" as RL

Item {
    Flickable {
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        contentWidth: width
        contentHeight: text.height

        anchors.fill: parent

        Text {
            id: text

            width: parent.width
            textFormat: Text.RichText
            wrapMode: TextEdit.WordWrap
            text: "
            <style>
                    h1 { color: %1; }
                    h3 { color: %2; }

                    body {
                        margin-left: %3px;
                    }

                    p, h3 {
                        margin-left: %4px;
                        font-size: %5px;
                    }
            </style>"
            .arg(root.primaryColor)
            .arg(root.secondaryColor)
            .arg(RL.calcSize("width", 10))
            .arg(RL.calcSize("width", 5))
            .arg(RL.calcSize("width", 15)) +

            "
            <body>
                <h1>Dim</h1>

                <h3>Enable</h3>
                <p>If you want to enable or disable dimming of room, you have to tap on power button.</p>

                <h3>Dim</h3>
                <p>To dim your light you have to set your desired dim on slider and you have to have enabled dimming.</p>
            </body>
            "
        }
    }
}
