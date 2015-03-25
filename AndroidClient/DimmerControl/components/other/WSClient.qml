import QtQuick 2.0
import Qt.WebSockets 1.0

import "../../logic/channelLogic.js" as CL
import "../../logic/messageController.js" as Socket

WebSocket {
    id: socket

    signal reconnect()

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
                console.log("Closed");
                socket.reconnect()
                break;

            case WebSocket.Error:
                root.connected = false
                console.log("Error (" + socket.errorString + ")")
                break;
        }
    }

    onReconnect: SequentialAnimation {
        NumberAnimation { duration: 200 }
        ScriptAction { script: { socket.active = false; socket.active = true } }
    }


    onTextMessageReceived: {
        var data = JSON.parse(message)

        if(data.action == "luminosity_read") {
            if(tempData.actualChannel != -1)
                root.luminosity = (1024 - data.readings[tempData.actualSensorChannel.toString()]) / 102.4
        }

        else if(data.action == "init_all_pins")
            tempData.pinList = data.pins

        else if(data.action == "init_schedule_point") {
            if(tempData.actualChannel == data.pin) {
                tempData.graph.addPoint(data.hour, data.minute, data.power)
            }
        }

        else if(data.action == "remove_schedule_point") {
            if(tempData.actualChannel == data.pin) {
                tempData.graph.removePoint(data.hour, data.minute)
            }
        }

        else if(data.action == "init_channel") {
            if(!CL.roomExists(data.pin))
                CL.addRoom(data.title, data.pin, data.sensor_channel, false)
        }

        else if(data.action == "remove_channel")
            CL.popRoom(data.pin, false)

        else if(data.action == "lock") {
            if(data.pin == tempData.actualChannel) {
                if(data.target == "dim")
                    tempData.lockDim = data.lock
                else if(data.target == "schedule")
                    tempData.lockSchedule = data.lock
            }
        }

        else if(data.action == "set_dim") {
            if(tempData.actualChannel == data.pin)
                root.slider.setValue(data.dim, true)
        }

        else if(data.action == "channel_synchronization_done") {
            console.log("sync_done")
            CL.autoSelectChannel(last_channel)
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

