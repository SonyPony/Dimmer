import threading
import time
import json
from smbus import SMBus
from Hardware import AnalogReader
import logging
import RPIO.PWM as PWM
import tornado.ioloop
import tornado.web
from tornado.websocket import WebSocketHandler

"""class AnalogReader(threading.Thread):
     def __init__(self, socket, adress):
        threading.Thread.__init__(self)
        self.bus = SMBus(1)
        self.bus.write_byte(adress, 0)
        #self.bus.write_byte(0x49, 0)
        self.last_reading = -1
        self.socket = socket
        self.adress = adress

     def run(self):
        while True:
            reading = self.bus.read_byte(self.adress)
            time.sleep(0.3)
            #logging.warning(reading)
            #logging.warning(self.bus.read_byte(0x49))
            if abs(self.last_reading - reading) > 1:
                self.last_reading = reading
                self.socket.write_message(str(self.last_reading))
"""
class WSHandler(WebSocketHandler):
    clients = []
    channels = []    

    def __init__(self, application, request, **kwargs):
        super(WSHandler, self).__init__(application, request, **kwargs)
        self.led = PWM.Servo(0, 10000, 1)
        PWM.set_loglevel(PWM.LOG_LEVEL_ERRORS)
        
        self.reader = AnalogReader(self, 0x48)
        self.reader.start()
	#dodělat jako dotaz na DB
        #self.dim = 0

    def open(self):
        WSHandler.clients.append(self)
        logging.warning("New")

    def on_close(self):
        if self in WSHandler.clients:
            WSHandler.clients.remove(self)
            
    def on_message(self, message):
        msg = json.loads(message)
        command = msg["command"]
        
        if command == "dim":
            try:
                self.led.set_servo(msg["pin"], pulse_width_us = int(msg["value"])*100)
                #WSHandler.channels[msg["pin"]] = msg["value"]
            except RuntimeError:
                self.led.set_servo(msg["pin"], 9990)
                #WSHandler.channels[msg["pin"]] = 100
        elif command == "add_channel":
            pass#WSHandler.channels[msg["pin"]] = 0

application = tornado.web.Application([
    (r"/", WSHandler),    
])

if __name__ == "__main__":
    application.listen(8888)
    tornado.ioloop.IOLoop.instance().start()

