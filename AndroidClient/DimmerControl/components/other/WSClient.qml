import QtQuick 2.0
import Qt.WebSockets 1.0

import "../../logic/channelLogic.js" as CL
import "../../logic/messageController.js" as Socket

WebSocket {
    id: socket

    active: false
    //url: "ws://169.254.29.212:8888"

    onStatusChanged: {
        var actualStatus = socket.status

        switch(actualStatus) {
            case WebSocket.Connecting:
                console.log("Connecting");
                break;

            case WebSocket.Open:
                console.log("Open");
                root.connected = true
                CL.deleteAllChannels()
                break;

            case WebSocket.Closing:
                console.log("Closing");
                break;

            case WebSocket.Closed:
                root.connected = false
                //reconnecting
                socket.active = false
                socket.active = true

                console.log("Closed");
                break;

            case WebSocket.Error:
                root.connected = false
                console.log("Error (" + socket.errorString + ")")
                break;
        }
    }

    onTextMessageReceived: {
        var data = JSON.parse(message)

        if(data["action"] == "luminosity_read") {
            if(tempData.actualChannel != -1)
                root.luminosity = 255 - data["readings"][tempData.actualSensorAddress][tempData.actualSensorChannel]
        }

        else if(data["action"] == "init_channel") {
            CL.addRoom(data["title"], data["pin"], (data["sensor_address"] + " - " + data["sensor_channel"]), false)
        }

        else if(data["action"] == "remove_channel")
            CL.popRoom(data["pin"], false)

        else if(data["action"] == "lock") {
            if(data["pin"] == tempData.actualChannel)
                root.lock = data["lock"]
        }

        else if(data["action"] == "set_dim") {
            if(tempData.actualChannel == data["pin"])
                root.slider.setValue(data["dim"], true)
        }
    }
    Component.onCompleted: {
        var ip = fileStream.read()
        if(ip != "") {
            socket.url = ip
            socket.active = true
        }
        loadingScreen.hide()
    }
}

