//.import "channelLogic.js" as CM

function setLuminosity(readings) {
    return 255 - data["readings"][tempData.actualSensorAddress][tempData.actualSensorChannel]
}

function sendLock(pin, lock) {
    var data = {}
    data.action = "lock"
    data.lock = lock
    data.pin = pin

    root.socket.sendTextMessage(JSON.stringify(data))
}

function setLock(pin, lock, component) {
    if(pin == tempData.actualChannel)
        component.lock = lock
}

function sendDim(dim, pin) {
    var data = {}
    data.action = "dim"
    data.pin = pin
    data.dim = dim

    if(!root.lock)
        root.socket.sendTextMessage(JSON.stringify(data))
}

function removeChannel(pin) {
    var data = {}
    data.action = "remove_channel"
    data.pin = pin

    root.socket.sendTextMessage(JSON.stringify(data))
}

function sendChannel(roomLabel, pin, sensorAddress, sensorChannel) {
    var data = {}
    data.action = "init_channel"
    data.title = roomLabel
    data.pin = pin
    data.sensor_address = sensorAddress
    data.sensor_channel = sensorChannel

    root.socket.sendTextMessage(JSON.stringify(data))
}

function requestDim() {
   var data = {
       "action": "get_dim",
       "pin": tempData.actualChannel
   }

   root.socket.sendTextMessage(JSON.stringify(data))
}

function requestAllChannels() {
    var data = {}
    data.action = "init_all_channels"

    root.socket.sendTextMessage(JSON.stringify(data))
}
