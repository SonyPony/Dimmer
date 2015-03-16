import QtQuick 2.0
import "../../responsivity/responsivityLogic.js" as RL

Item {
    Flickable {
        id: flick

        clip: true
        boundsBehavior: Flickable.StopAtBounds

        contentWidth: width
        contentHeight: text.height

        anchors.fill: parent

        Text {
            id: text

            width: parent.width - RL.calcSize("width", 7)
            textFormat: Text.RichText
            wrapMode: TextEdit.WordWrap
            text: "
            <style>
                    .title {
                        color: %1;
                        font-size: %6px;
                    }
                    .subtitle { color: %2; }

                    body {
                        margin-left: %3px;
                    }

                    p, .subtitle {
                        margin-left: %4px;
                        font-size: %5px;
                    }
            </style>"
            .arg(root.primaryColor)
            .arg(root.primaryColor)
            .arg(RL.calcSize("width", 15))
            .arg(RL.calcSize("width", 10))
            .arg(RL.calcSize("height", 25))
            .arg(RL.calcSize("height", 35)) +

            '
            <body>
                <p class="title"><b>Dim</b></p>
                    <p>Allows you to dim light and to see luminosity in your room.</p>

                    <p class="subtitle">Enable</p>
                        <p>If you want to enable or disable dimming of room, tap on <b>power button</b>.</p>

                        <p class="subtitle">Dim</p>
                        <p>
                            At first you have to choose channel in <b>Channel tab</b>.
                            To dim your light you have to set your desired dim on <b>slider</b> and you have to have enabled dimming.
                        </p>

                <p class="title"><b>Schedule</b></p>
                    <p>Allows you to dim light according to time.</p>

                    <p class="subtitle">Create schedule point</p>
                        <p>
                            Tap on "Add" button and set your desired time and light power and then tap again on <b>"Add"</b> button.
                        </p>

                    <p class="subtitle">Change power of schedule point</p>
                        <p>
                            To change power of schedule point, <b>drag point</b> to desired power or recreate point.
                        </p>

                     <p class="subtitle">Delete schedule point</p>
                        <p>
                            To delete schedule point and <b>tap on the point</b> a then tap on delete.
                        </p>

                <p class="title"><b>Channel</b></p>
                    <p>Allows you to control more rooms.</p>

                    <p class="subtitle">Create new channel</p>
                        <p>
                            To create channel tap on <b>"Add"</b> button and then choose desired settings. Look at your Dim-box and set pin and sensor channel.
                        </p>

                    <p class="subtitle">Delete channel</p>
                        <p>
                            To delete channel, <b>tap on channel</b>, which you want to delete and then tap on red cross.
                        </p>

                    <p class="subtitle">Select channnel</p>
                        <p>
                            To select channel, tap on desired channel and then tap on <b>"Select room"</b>.
                        </p>

                    <p class="subtitle">Hide channel options</p>
                        <p>
                            To hide options <b>tap on number</b>(pin of your room on Dim-box)
                        </p>

                <p class="title"><b>Settings</b></p>
                    <p>Allows you to connect to Dim-Box</p>
            </body>
            '
        }
    }

    Rectangle { //scrollbar
        y: flick.visibleArea.yPosition * flick.height
        width: RL.calcSize("width", 4)
        height: flick.visibleArea.heightRatio * flick.height

        color: root.secondaryColor

        anchors.right: parent.right
    }
}
