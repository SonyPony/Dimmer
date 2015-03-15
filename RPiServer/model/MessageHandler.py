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

    def __broadcast_data(self, message):
        """
        :param message: string
        """

        for client in self.__clients:
            client.write_message(dumps(message))

    def set_dim(self, pin, dim):
        """
        :param room_label: string
        :param dim: int
        """
        self.__PWMOutputs[pin].width = dim
        self.__DB.data["dim"][pin] = dim

        self.__broadcast_data({
            "action": "dim",
            "dim": dim
        })

    def get_dim(self, pin):
        """
        :param room_label: string
        :return: int
        """
        return self.__DB.data["dim"][pin]

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
