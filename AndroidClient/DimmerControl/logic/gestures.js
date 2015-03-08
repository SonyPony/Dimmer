function checkSwipe(startX, endX, len) {
    var diffencial = startX - endX
    if(Math.abs(diffencial) >= len)
        switch(diffencial / Math.abs(diffencial)) {
            case -1:
                return "swipeRight"
            case 1:
                return "swipeLeft"
        }
}

