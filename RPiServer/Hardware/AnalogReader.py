__author__ = 'Sony'

import threading
from smbus import SMBus
from json import dumps
from time import sleep

class AnalogReader(threading.Thread):
    def __init__(self, socket, address):
        """
        :type address: list
        """

        super(AnalogReader, self).__init__()
        AnalogReader.number_of_channels = 4

        self.__bus = SMBus(1)
        #self.bus.write_byte(address, 0)
        self.__last_readings = {i: [-1 for _ in range(AnalogReader.number_of_channels)] for i in address}
        self.__socket = socket
        self.__address = address

    def __read_all_channels(self, address):
        """
        :param address: int
        :return: list
        """

        readings = list()
        for channel in range(AnalogReader.number_of_channels):
            self.__bus.write_byte(address, channel)
            readings.append(self.__bus.read_byte(address))
        return readings

    def __send_readings(self, address, readings):
        """
        :param readings: list
        :param address: int
        :return: None
        """

        values_changed = False

        for channel, single_reading in enumerate(readings):
            if abs(self.__last_readings[address][channel] - single_reading > 1):
                self.__last_readings[address][channel] = single_reading
                values_changed = True

        if values_changed:
            data = dict()
            data["action"] = "reading_analog"
            data["address"] = address
            data["readings"] = self.__last_readings[address]
            self.__socket.write_message(dumps(data))

    def run(self):
        while True:
            for single_address in self.__address:
                readings = self.__read_all_channels(single_address)
                self.__send_readings(single_address, readings)
            sleep(0.3)

    """def run(self):
        while True:
            for single_address in self.__address:
                reading = self.__read_all_values(single_address)

                if abs(self.__last_reading[] - reading) > 1:    #some tolerance
                    self.__last_reading = reading
                    self.__socket.write_message(str(self.__last_reading))
            sleep(0.3)"""