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
        message = loads(message)

        if message["action"] == "dim":
            WSHandler.message_handler.set_dim(message["pin"], message["dim"])
        elif message["action"] == "get_dim":
            WSHandler.message_handler.get_dim(message["pin"], self)


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

