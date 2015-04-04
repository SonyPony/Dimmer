from json import loads
from model.MessageHandler import MessageHandler
from containers.HardwareContainer import HardwareContainer
from managers.Scheduler import Scheduler
import tornado.ioloop
import tornado.web
from tornado.websocket import WebSocketHandler
import threading

class WSHandler(WebSocketHandler):
    def __init__(self, application, request, **kwargs):
        super(WSHandler, self).__init__(application, request, **kwargs)

    def open(self):
        WSHandler.clients.append(self)
        WSHandler.scheduler.get_time(True)

    def on_close(self):
        if self in WSHandler.clients:
            WSHandler.clients.remove(self)
            
    def on_message(self, message):
        print(message)
        message = loads(message)

        if message["action"] in ["init_channel", "remove_channel", "lock", "remove_schedule_point", "init_schedule_point"]:
            WSHandler.message_handler.broadcast_data(message, self)

        if message["action"] == "dim":
            WSHandler.message_handler.set_dim(message["pin"], message["dim"])
        elif message["action"] == "get_dim":
            WSHandler.message_handler.send_dim(message["pin"], self)
        elif message["action"] == "save_last_dim":
            WSHandler.message_handler.save_last_dim(message["pin"])
        elif message["action"] == "set_last_dim":
            WSHandler.message_handler.set_last_dim(message["pin"])
        elif message["action"] == "init_all_pins":
            WSHandler.message_handler.send_all_pins(self)
        elif message["action"] == "init_channel":
            WSHandler.message_handler.init_channel(message["title"], message["pin"], message["sensor_channel"])
        elif message["action"] == "remove_channel":
            WSHandler.message_handler.remove_channel(message["pin"])
        elif message["action"] == "init_all_channels":
            WSHandler.message_handler.send_all_channels(self)
        elif message["action"] == "lock" and message["target"] == "graph":
            WSHandler.message_handler.lock_schedule(message["pin"], message["lock"])
        elif message["action"] == "init_schedule_point":
            WSHandler.message_handler.init_schedule_point(message["pin"], message["hour"], message["minute"], message["power"])
        elif message["action"] == "remove_schedule_point":
            WSHandler.message_handler.remove_schedule_point(message["pin"], message["hour"], message["minute"])
        elif message["action"] == "init_all_schedule_points":
            WSHandler.message_handler.send_all_schedule_points(message["pin"], self)


WSHandler.clients = []

application = tornado.web.Application([
    (r"/", WSHandler),    
])

if __name__ == "__main__":
    application.listen(8888)
    hardware_container = HardwareContainer()
    WSHandler.message_handler = MessageHandler(hardware_container.PWMOutputs, WSHandler.clients)
    WSHandler.scheduler = Scheduler(WSHandler.message_handler.data(), WSHandler.message_handler.set_dim, WSHandler.message_handler.send_dim, WSHandler.message_handler.set_time)

    serverloop = tornado.ioloop.IOLoop.instance()
    scheduleloop = tornado.ioloop.PeriodicCallback(WSHandler.scheduler.check, 15000)

    threading.Thread(target=WSHandler.message_handler.send_illuminance).start()
    scheduleloop.start()
    serverloop.start()

