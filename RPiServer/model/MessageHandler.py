__author__ = 'Sony'
from json import dumps
from model.Database import Database
from managers.LuminosityManager import LuminosityManager
from settings import Settings

class MessageHandler():
    def __init__(self, PWMOutputs, clients):
        self.__DB = Database("db")
        self.__clients = clients
        self.__PWMOutputs = PWMOutputs
        self.__luminosity_manager = LuminosityManager()

        #set light on according to DB
        for pin in self.__DB.data:
            self.__PWMOutputs[int(pin)].width = self.__DB.data[pin]["dim"]

    def data(self):
        return self.__DB.data

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
        self.__DB.data[str(pin)]["dim"] = dim
        self.__DB.save()

    def send_dim(self, pin, requester=None):
        """
        :param pin: int
        """

        data = {
            "action": "set_dim",
            "pin": pin,
            "dim": self.__DB.data[str(pin)]["dim"]
        }

        if requester:
            self.send_data_to(data, requester)
        else:
            self.broadcast_data(data)

    def send_all_channels(self, requester):
        data = {
            "action": "init_channel"
        }
        
        for k, v in self.__DB.data.items():
            data["sensor_channel"] = v["sensor_channel"]
            data["pin"] = v["pin"]
            data["title"] = v["title"]
            self.send_data_to(data, requester)

        data = {
            "action": "channel_synchronization_done"
        }

        self.send_data_to(data, requester)

    def init_channel(self, room_label, pin, channel):
        """
        :param room_label: string
        :param pin: int
        :param address: int
        :param channel: int
        """

        self.__DB.data[str(pin)] = {
            "dim": 0,
            "sensor_channel": channel,
            "pin": pin,
            "title": room_label,
            "schedule": {}
        }
        self.__DB.save()

    def remove_channel(self, pin):
        """
        :param pin: int
        """

        self.__DB.data.pop(str(pin))
        self.__DB.save()

    def send_all_schedule_points(self, pin, requester):
        data = {
            "action": "init_schedule_point"
        }

        for k, v in self.__DB.data[str(pin)]["schedule"].items():
            data["pin"] = pin
            data["power"] = v
            data["hour"] = int(int(k) / 100)
            data["minute"] = int(k) % 100
            print(dumps(data))
            self.send_data_to(data, requester)

    def init_schedule_point(self, pin, hour, minute, power):
        """
        :param pin: int
        :param hours: int
        :param minutes: int
        :param power: int
        """

        self.__DB.data[str(pin)]["schedule"][str(int(hour) * 100 + int(minute))] = int(power)
        self.__DB.save()

    def remove_schedule_point(self, pin, hour, minute):
        """
        :param pin: int
        :param hours: int
        :param minutes: int
        """

        self.__DB.data[str(pin)]["schedule"].pop(str(int(hour) * 100 + int(minute)))
        self.__DB.save()

    def send_all_pins(self, requester):
        data = {
            "action": "init_all_pins",
            "pins": Settings.PWM_PINS
        }

        self.send_data_to(data, requester)

    def send_luminosity(self):
        while True:
            luminosity = self.__luminosity_manager.readings()
            print(luminosity)
            data = {
                "action": "luminosity_read",
                "readings": luminosity
            }
            self.broadcast_data(data)
