__author__ = 'Sony'

from hardware.AnalogReader import AnalogReader
from settings import Settings

class LuminosityManager():
    def __init__(self):
        self.__reader = AnalogReader()

    def readings(self):
        """
        :return: dict
        """

        self.__reader.read_all()

        readings = self.__reader.readings
        luminosity = dict()
        print("read:", readings)
        for key, single_reading in readings.items():
            voltage = self.__raw2voltage(single_reading)
            resistance = self.__voltage2resistance(voltage)
            luminosity[key] = self.__resistance2luminosity(resistance)

        return luminosity

    def __raw2voltage(self, raw_value):
        """
        :param raw_value: int
        :return: float
        """
        raw_value = 0 if raw_value <= 15 else raw_value
        return Settings.REFERENCE_VOLTAGE * (raw_value / Settings.AD_PRECISION)

    def __voltage2resistance(self, voltage):
        """
        :param voltage: float
        :return: float
        """

        return (voltage * Settings.RB1) / (Settings.REFERENCE_VOLTAGE - voltage)

    def __resistance2luminosity(self, resistance):
        """
        :param resistance: float
        :return: float
        """

        if resistance == 0:
            return 0

        inverted_gama = 1 / Settings.GAMA
        return ((Settings.R_AT_10_LUX ** (inverted_gama)) * 10 * (resistance ** (-inverted_gama)))