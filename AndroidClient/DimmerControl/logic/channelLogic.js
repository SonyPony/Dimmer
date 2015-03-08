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
    tempData.actualSensorAddress = tempData.channels[newIndex][2][0] + tempData.channels[newIndex][2][1]
    tempData.actualSensorChannel = tempData.channels[newIndex][2][tempData.channels[newIndex][2].length - 1]
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

function popRoom(pin) {
    var removingItemKey = -1
    var element

    for(var i = 0; i < repeater.count; i++) {
        element = repeater.itemAt(i).singleElement

        if(element.pin == pin) {
            element.remove()
            removingItemKey = i
        }
        else if(i > removingItemKey && removingItemKey != -1)
            element.move()
    }
}

function addRoom(title, pin, sensorPin) {
    repeater.newItemIndex = pin
    channels.push([title, pin, sensorPin])
    channelsChanged()
    repeater.newItemIndex = -1
}
