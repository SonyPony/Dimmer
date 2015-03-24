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
        self.__DB.data[str(pin)]["dim"] = dim
        self.__DB.save()

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

    def send_all_channels(self, requester):
        data = {
            "action": "init_channel"
        }
        
        for k, v in self.__DB.data.items():
            data["sensor_channel"] = v["sensor_channel"]
            data["pin"] = v["pin"]
            data["title"] = v["title"]
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

        self.__DB.data[str(pin)]["schedule"][str(hour * 100) + str(minute)] = int(power)
        self.__DB.save()

    def remove_schedule_point(self, pin, hour, minute):
        """
        :param pin: int
        :param hours: int
        :param minutes: int
        """

        self.__DB.data[str(pin)]["schedule"].pop(str(hour * 100) + str(minute))
        self.__DB.save()

    def send_all_pins(self, requester):
        data = {
            "action": "init_all_pins",
            "pins": Settings.PWM_PINS
        }

        self.send_data_to(data, requester)

    def send_luminosity(self):
        while True:
            self.__reader.read_all()

            data = {
                "action": "luminosity_read",
                "readings": self.__reader.readings
            }
            self.broadcast_data(data)
