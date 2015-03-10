function setLuminosity(readings) {
    return 255 - data["readings"][tempData.actualSensorAddress][tempData.actualSensorChannel]
}

function sendLock(pin, lock) {
    var data = {}
    data.action = "lock"
    data.lock = lock

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

    root.socket.sendTextMessage(JSON.stringify(data))
}

function initChannel(roomLabel, pin, sensorAddress, sensorChannel) {

}

function removeChannel(pin) {

}

