__author__ = 'Sony'

from settings import Settings
from smbus import SMBus

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
                readings[address].append(self.__bus.read_byte(address))
        return readings