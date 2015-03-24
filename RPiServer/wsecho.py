from json import loads
from model.MessageHandler import MessageHandler
import tornado.ioloop
import tornado.web
from tornado.websocket import WebSocketHandler
import threading

class WSHandler(WebSocketHandler):
    def __init__(self, application, request, **kwargs):
        super(WSHandler, self).__init__(application, request, **kwargs)

    def open(self):
        WSHandler.clients.append(self)

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
            WSHandler.message_handler.get_dim(message["pin"], self)
        elif message["action"] == "init_all_pins":
            WSHandler.message_handler.send_all_pins(self)
        elif message["action"] == "init_channel":
            WSHandler.message_handler.init_channel(message["title"], message["pin"], message["sensor_channel"])
        elif message["action"] == "remove_channel":
            WSHandler.message_handler.remove_channel(message["pin"])
        elif message["action"] == "init_all_channels":
            WSHandler.message_handler.send_all_channels(self)
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
    WSHandler.message_handler = MessageHandler(WSHandler.clients)
    serverloop = tornado.ioloop.IOLoop.instance()

    threading.Thread(target=WSHandler.message_handler.send_luminosity).start()
    serverloop.start()

