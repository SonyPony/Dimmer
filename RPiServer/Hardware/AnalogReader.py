__author__ = 'Sony'

from settings import Settings
from smbus import SMBus
import time

class AnalogReader():
    def __init__(self):
        self.__bus = SMBus(1)
        self.__readings = dict()

    @property
    def readings(self):
        return self.__readings

    @readings.setter
    def readings(self, value):
        self.__readings = value

    def read_all(self):
        """
        :param address: int
        :return: list
        """

        self.__readings = dict()

        for address in Settings.ADDRESS:
            self.__readings[address] = list()
            for channel in range(Settings.NUMBER_OF_CHANNELS):
                time.sleep(0.2)
                self.__bus.write_byte(address, channel)
                time.sleep(0.3)
                self.__readings[address].append(self.__bus.read_byte(address))

