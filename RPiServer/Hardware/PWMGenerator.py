__author__ = 'Sony'

import RPIO.PWM as PWM

PWM.set_loglevel(PWM.LOG_LEVEL_ERRORS)

class PWMGenerator(object):
    def __init__(self, pin, width):
        """
        :param pin: int
        :param width: int
        """
        
        self.__pin = pin
        self.__width = width
        self.__generator = PWM.Servo(0, 10000, 1)

    @property
    def width(self):
        return self.__width

    @width.setter
    def width(self, value):
        """
        :param value: int
        """

        self.__width = value
        try:
            self.__generator.set_servo(self.__pin, pulse_width_us = value * 100)
        except RuntimeError:
            self.__generator.set_servo(self.__pin, 9990)
