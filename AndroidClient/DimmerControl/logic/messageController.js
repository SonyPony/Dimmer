function sendLock(pin, target, lock) {
    var data = {}
    data.action = "lock"
    data.target = target
    data.lock = lock
    data.pin = pin

    root.socket.sendTextMessage(JSON.stringify(data))
}

function sendDim(dim, pin) {
    var data = {}
    data.action = "dim"
    data.pin = pin
    data.dim = dim

    if(!tempData.lockDim)
        root.socket.sendTextMessage(JSON.stringify(data))
}

function removeChannel(pin) {
    var data = {}
    data.action = "remove_channel"
    data.pin = pin

    root.socket.sendTextMessage(JSON.stringify(data))
}

function sendChannel(roomLabel, pin, sensorChannel) {
    var data = {}
    data.action = "init_channel"
    data.title = roomLabel
    data.pin = pin
    data.sensor_channel = sensorChannel

    root.socket.sendTextMessage(JSON.stringify(data))
}

function requestDim() {
    var data = {
        "action": "get_dim",
        "pin": tempData.actualChannel
    }

    if(tempData.actualChannel != -1)
        root.socket.sendTextMessage(JSON.stringify(data))
}

function requestAllChannels() {
    var data = {}
    data.action = "init_all_channels"

    root.socket.sendTextMessage(JSON.stringify(data))
}
