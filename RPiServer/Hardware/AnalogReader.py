__author__ = 'Sony'

from settings import Settings
from smbus import SMBus
import time

class AnalogReader():
    def __init__(self):
        self.__bus = SMBus(1)

    def read_all(self):
        """
        :param address: int
        :return: list
        """

        readings = dict()

        for address in Settings.ADDRESS:
            readings[address] = list()

            for channel in range(Settings.NUMBER_OF_CHANNELS):
                self.__bus.write_byte(address, channel)
                time.sleep(0.2)
                readings[address].append(self.__bus.read_byte(address))
        return readings
