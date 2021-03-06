function setTime(hour, minute) {
    tempData.graph.timeLineHour = hour
    tempData.graph.timeLineMinute = minute
}

function sendLock(pin, target, lock) {
    var data = {}
    data.action = "lock"
    data.target = target
    data.lock = lock
    data.pin = pin

    root.socket.sendTextMessage(JSON.stringify(data))
}

function saveLastDim() {
    var data = {}
    data.action = "save_last_dim"
    data.pin = tempData.actualChannel

    root.socket.sendTextMessage(JSON.stringify(data))
}

function setLastDim() {
    var data = {}
    data.action = "set_last_dim"
    data.pin = tempData.actualChannel

    root.socket.sendTextMessage(JSON.stringify(data))
}

function sendDim(dim, pin, last) {
    var data = {}
    data.action = "dim"
    data.pin = pin
    data.dim = dim
    data.last = last

    if(!tempData.lockDim)
        root.socket.sendTextMessage(JSON.stringify(data))
}

function sendSchedulePoint(pin, hour, minute, power) {
    var data = {}
    data.action = "init_schedule_point"
    data.pin = pin
    data.hour = hour
    data.minute = minute
    data.power = power

    root.socket.sendTextMessage(JSON.stringify(data))
}

function removeSchedulePoint(pin, hour, minute) {
    var data = {}
    data.action = "remove_schedule_point"
    data.pin = pin
    data.hour = hour
    data.minute = minute

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

    root.socket.sendTextMessage(JSON.stringify(data))
}

function requestAllSchedulePoints(pin) {
    var data = {}
    data.action = "init_all_schedule_points"
    data.pin = pin

    root.socket.sendTextMessage(JSON.stringify(data))
}

function requestAllPins() {
    var data = {}
    data.action = "init_all_pins"

    root.socket.sendTextMessage(JSON.stringify(data))
}

function requestAllChannels() {
    var data = {}
    data.action = "init_all_channels"

    root.socket.sendTextMessage(JSON.stringify(data))
}
