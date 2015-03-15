import QtQuick 2.0
import Qt.WebSockets 1.0

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
                connectionStatus.color = root.primaryColor
                console.log("Open");
                break;

            case WebSocket.Closing:
                console.log("Closing");
                break;

            case WebSocket.Closed:
                connectionStatus.color = root.cancelColor
                console.log("Closed");

                //reconnecting
                socket.active = false
                socket.active = true
                break;

            case WebSocket.Error:
                connectionStatus.color = root.cancelColor
                console.log("Error (" + socket.errorString + ")")
                break;
        }
    }

    onTextMessageReceived: {
        var data = JSON.parse(message)

        if(data["action"] == "luminosity_read") {
            root.luminosity = 255 - data["readings"][tempData.actualSensorAddress][tempData.actualSensorChannel]

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

