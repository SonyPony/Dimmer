__author__ = 'Sony'

from settings import Settings
import spidev
import time

class AnalogReader():
    def __init__(self):
        self.__spi = spidev.SpiDev()
        self.__spi.open(0, 0)
        self.__readings = dict()

    @property
    def readings(self):
        return self.__readings

    @readings.setter
    def readings(self, value):
        self.__readings = value

    def read_channel(self, channel):
        adc = self.__spi.xfer2([1, (8 + channel) << 4, 0])
        return ((adc[1] & 3) << 8) + adc[2]

    def read_all(self):
        """
        :param address: int
        :return: list
        """

        self.__readings = dict()

        for channel in range(Settings.NUMBER_OF_CHANNELS):
            self.__readings[channel] = self.read_channel(channel)
            time.sleep(0.2)
