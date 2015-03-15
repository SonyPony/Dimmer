.import "messageController.js" as Socket

function parseSensorAddress(pin) {
    return {
        "address": parseInt(pin[0] + pin[1]),
        "channel": parseInt(pin[pin.length -1])
    }
}

function setChannel(pin, room_label, address, channel) {
    tempData.actualChannel = pin
    infoPanel.label = room_label
    tempData.actualSensorAddress = address
    tempData.actualSensorChannel = channel
}

function getRoomIndexFromPin(pin) {
    for(var key in tempData.channels)
        if(tempData.channels[key][1] == pin) {
            return key
        }
}

function setRoom(newIndex) {  
    newIndex = parseInt(newIndex)
    infoPanel.label = tempData.channels[newIndex][0]
    tempData.actualChannel = tempData.channels[newIndex][1]

    var sensor = parseSensorAddress(tempData.channels[newIndex][2])

    tempData.actualSensorAddress = sensor.address
    tempData.actualSensorChannel = sensor.channel
}

function setPreviousRoom() {
    var index = getRoomIndexFromPin(tempData.actualChannel)
    var newIndex

    if(index == 0)
        newIndex = tempData.channels.length -1
    else
        newIndex = parseInt(index) - 1

    setRoom(newIndex)
}

function setNextRoom() {
    var index = getRoomIndexFromPin(tempData.actualChannel)
    var newIndex

    if(index == tempData.channels.length - 1)
        newIndex = 0

    else
        newIndex = parseInt(index) + 1

    setRoom(newIndex)
}

function popRoom(pin, broadcast) {
    var removingItemKey = -1
    var element

    if(broadcast)
        Socket.removeChannel(pin)

    for(var i = 0; i < root.channelList.count; i++) {
        element = root.channelList.itemAt(i).singleElement

        if(element.pin == pin) {
            element.remove()
            removingItemKey = i
        }
        else if(i > removingItemKey && removingItemKey != -1)
            element.move()
    }
}

function removeUsedPin(pin) {
    for(var key in tempData.pinList)
        if(pin == tempData.pinList[key])
            tempData.pinList.splice(key, 1)
    tempData.pinListChanged()
}


function addRoom(title, pin, sensorPin, broadcast) {
    var sensor = parseSensorAddress(sensorPin)

    removeUsedPin(pin)

    root.channelList.newItemIndex = pin
    tempData.channels.push([title, pin, sensorPin])
    tempData.channelsChanged()
    root.channelList.newItemIndex = -1

    if(broadcast)
        Socket.sendChannel(title, pin, sensor.address, sensor.channel)
}
