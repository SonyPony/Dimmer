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
                <p class="title"><b>' + qsTr('Dim') + '</b></p>
                    <p>' + qsTr('Allows you to dim light and to see luminosity in your room') + '.</p>' +

                    '<p class="subtitle">' + qsTr('Enable') + '</p>
                        <p>' + qsTr('If you want to enable or disable dimming of room, tap on') + '<b> ' + qsTr('power button') + '</b>.</p>

                        <p class="subtitle">' + qsTr('Dim') + '</p>
                        <p>' +
                            qsTr('At first you have to choose channel in ') + '<b>' + qsTr('Channel tab') + '</b>.' +
                            qsTr('To dim your light you have to set your desired dim on') + ' <b>' + qsTr('slider') + '</b> ' + qsTr('and you have to have enabled dimming') + '.' +
                        '</p>

                <p class="title"><b>' + qsTr('Schedule') + '</b></p>
                    <p>' + qsTr('Allows you to dim light according to time.') + '</p>

                    <p class="subtitle">' + qsTr('Create schedule point') + '</p>
                        <p>' +
                            qsTr('Tap on "Add" button and set your desired time and light power and then tap again on ') + '<b>' + qsTr('"Add"') + '</b> ' + qsTr('button') + '.
                        </p>

                    <p class="subtitle">' + qsTr('Change power of schedule point') + '</p>
                        <p>' +
                            qsTr('To change power of schedule point') + ', <b>' + qsTr('drag point') + '</b> ' + qsTr('to desired power or recreate point') + '.
                        </p>

                     <p class="subtitle">' + qsTr('Delete schedule point') + '</p>
                        <p>' +
                            qsTr('To delete a schedule point') + ' <b>' + qsTr('tap on the point') + '</b> ' + qsTr('and then tap on delete') + '.
                        </p>

                <p class="title"><b>' + qsTr('Channel') + '</b></p>
                    <p>' + qsTr('Allows you to control more rooms') + '.</p>

                    <p class="subtitle">' + qsTr('Create new channel') + '</p>
                        <p>' +
                            qsTr('To create channel tap on ') + '<b>' + qsTr('"Add"') + '</b> ' + qsTr('button and then choose desired settings. Look at your Dim-box and set pin and sensor channel.') +
                        '</p>

                    <p class="subtitle">' + qsTr('Delete channel') + '</p>
                        <p>' +
                            qsTr('To delete channel,') + ' <b>' + qsTr('tap on channel') + '</b>' + qsTr(', which you want to delete and then tap on red cross.') +
                        '</p>

                    <p class="subtitle">' + qsTr('Select channnel') + '</p>
                        <p>' +
                            qsTr('To select channel, tap on desired channel and then tap on') + ' <b>' + qsTr('"Select room"') + '</b>.' +
                        '</p>

                    <p class="subtitle">' + qsTr('Hide channel options') + '</p>
                        <p>' +
                            qsTr('To hide options') + ' <b>' + qsTr('tap on number') + '</b>' + qsTr('(number of your room on Dim-box)') +
                        '</p>

                <p class="title"><b>' + qsTr('Settings') + '</b></p>
                    <p>' + qsTr('Allows you to connect to Dim-Box') + '</p>
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
