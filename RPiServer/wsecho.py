from json import loads
from model.MessageHandler import MessageHandler
import logging
import tornado.ioloop
import tornado.web
from tornado.websocket import WebSocketHandler

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



WSHandler.clients = []
#WSHandler.message_handler = MessageHandler(WSHandler.clients)

application = tornado.web.Application([
    (r"/", WSHandler),    
])

if __name__ == "__main__":
    a = []
    #handler = MessageHandler(a)
    application.listen(8888)
    WSHandler.message_handler = MessageHandler(WSHandler.clients)
    serverloop = tornado.ioloop.IOLoop.instance()
  
    luminosity_reader = tornado.ioloop.PeriodicCallback(WSHandler.message_handler.send_luminosity, 300)
    luminosity_reader.start()
    serverloop.start()

