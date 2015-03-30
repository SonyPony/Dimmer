.import "messageController.js" as Socket

function autoSelectChannel(configFile) {
    var last_pin = parseInt(configFile.read())

    for(var key in tempData.channels) {
        if((tempData.channels[key]["pin"] == last_pin && last_pin != "") || tempData.channels.length == 1) {
            setRoom(key)
            break;
        }
    }

    if(tempData.actualChannel == -1)    //choose first room
        setRoom(0)
}

function deleteAllChannels() {
    for(var key in tempData.channels) {
        channelDeleteManager.listOfDeleting.push(tempData.channels[key]["pin"])

    }
    channelDeleteManager.running = true
}

function roomExists(pin) {
    for(var key in tempData.channels)
        if(tempData.channels[key]["pin"] == pin) {
            return true
        }
    return false
}

function setChannel(pin, room_label, channel) {
    tempData.actualChannel = pin
    infoPanel.label = room_label
    tempData.actualSensorChannel = channel
}

function getRoomIndexFromPin(pin) {
    for(var key in tempData.channels)
        if(tempData.channels[key]["pin"] == pin) {
            return key
        }
}

function setNoneRoom() {
    infoPanel.label = ""
    tempData.actualChannel = -1
    tempData.actualSensorChannel = -1
}

function setRoom(newIndex) {  
    newIndex = parseInt(newIndex)
    infoPanel.label = tempData.channels[newIndex]["title"]
    tempData.actualChannel = tempData.channels[newIndex]["pin"]
    tempData.actualSensorChannel = tempData.channels[newIndex]["sensorPin"]
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

    if(tempData.actualChannel == pin)
        setNoneRoom()

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
    removeUsedPin(pin)

    root.channelList.newItemIndex = pin
    tempData.channels.push({"title": title, "pin": pin, "sensorPin": sensorPin})
    tempData.channelsChanged()
    root.channelList.newItemIndex = -1

    if(broadcast)
        Socket.sendChannel(title, pin, sensorPin)
}
