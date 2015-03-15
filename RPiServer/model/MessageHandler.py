__author__ = 'Sony'
from json import dumps
from model.Database import Database
from hardware.PWMGenerator import PWMGenerator
from hardware.AnalogReader import AnalogReader
from settings import Settings

class MessageHandler():
    def __init__(self, clients):
        self.__DB = Database("db")
        self.__clients = clients
        self.__PWMOutputs = {pin: PWMGenerator(pin, 0) for pin in Settings.PWM_PINS}
        self.__reader = AnalogReader()

    def broadcast_data(self, message, sender=None):
        """
        :param message: string
        """

        for client in self.__clients:
            if client != sender:
                client.write_message(dumps(message))

    def send_data_to(self, message, receiver):
        """
        :param message: string
        """

        for client in self.__clients:
            if client == receiver:
                client.write_message(dumps(message))

    def set_dim(self, pin, dim):
        """
        :param room_label: string
        :param dim: int
        """
        self.__PWMOutputs[pin].width = dim
        temp = self.__DB.data
        temp[str(pin)]["dim"] = dim
        self.__DB.data = temp

    def get_dim(self, pin, requester):
        """
        :param pin: int
        """
        data = {
            "action": "set_dim",
            "pin": pin,
            "dim": self.__DB.data[str(pin)]["dim"]

        }
        self.send_data_to(data, requester)


    def init_channel(self, room_label, pin, address, channel):
        """
        :param room_label: string
        :param pin: int
        :param address: int
        :param channel: int
        """
        data = {
            "address": address,
            "channel": channel,
            "pin": pin,
            "room_label": room_label
        }

        self.__DB.data["channels"][pin] = data
        data["action"] = "init"
        data["target"] = "channel"
        self.__broadcast_data(data)

    def remove_channel(self, pin):
        """
        :param pin: int
        """
        data = self.__DB.data["channels"][pin]
        self.__DB.data["channels"].pop(pin)
        data["action"] = "remove"
        data["action"] = "channel"
        self.__broadcast_data(data)

    def get_channels(self):
        """
        :return: dict
        """

        return self.__DB.data["channels"]

    def send_luminosity(self):
        readings = self.__reader.read_all()
        self.__broadcast_data(readings)
