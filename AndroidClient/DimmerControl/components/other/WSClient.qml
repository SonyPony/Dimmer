import QtQuick 2.0
import WebsocketClient 1.0

import "../../logic/channelLogic.js" as CL
import "../../logic/messageController.js" as Socket

WebsocketClient {
    id: socket

    Timer {
        id: reconnectTimer
        interval: 500
        running: false
        repeat: true
        onTriggered: socket.reconnect()
    }

    onStatusChanged: {
        if(status == WebsocketClient.Open) {
            root.connected = true
            reconnectTimer.running = false
            CL.deleteAllChannels()
        }

        else if(status == WebsocketClient.Closed) {
            root.connected = false
            if(!reconnectTimer.running)
                reconnectTimer.running = true
        }
    }

    Component.onCompleted: {
        var ip = fileStream.read()
        if(ip != "") {
            socket.url = ip
            socket.reconnect()
        }
        loadingScreen.hide()
    }

    onTextMessageReceived: {
        var data = JSON.parse(message)
        console.log(message)

        switch(data["action"]) {
            case "illuminance_read":
                if(tempData.actualChannel != -1)
                    root.illuminance = data.readings[tempData.actualSensorChannel.toString()]
                break;

            case "init_all_pins":
                tempData.pinList = data.pins
                break;

            case "init_schedule_point":
                if(tempData.actualChannel == data.pin)
                    tempData.graph.addPoint(data.hour, data.minute, data.power)
                break;

            case "remove_schedule_point":
                if(tempData.actualChannel == data.pin)
                    tempData.graph.removePoint(data.hour, data.minute)
                break;

            case "init_channel":
                if(!CL.roomExists(data.pin))
                    CL.addRoom(data.title, data.pin, data.sensor_channel, false)
                break;

            case "remove_channel":
                CL.popRoom(data.pin, false)
                break;

            case "lock":
                if(data.pin == tempData.actualChannel) {
                    if(data.target == "dim")
                        tempData.lockDim = data.lock
                    else if(data.target == "schedule")
                        tempData.lockSchedule = data.lock
                    else if(data.target == "graph")
                        tempData.graphEnable.active = !data.lock
                }
                break;

            case "set_dim":
                if(tempData.actualChannel == data.pin)
                    root.slider.setValue(data.dim, true)
                break;

            case "channel_synchronization_done":
                CL.autoSelectChannel(last_channel)
                break;

            case "set_time":
                Socket.setTime(data.hour, data.minute)
                break;
        }
    }
}
