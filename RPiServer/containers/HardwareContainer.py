__author__ = 'Sony'
from settings import Settings
from hardware.PWMGenerator import PWMGenerator

class HardwareContainer():
    def __init__(self):
        self.__PWMOutputs = {pin: PWMGenerator(pin, 0) for pin in Settings.PWM_PINS}

    @property
    def PWMOutputs(self):
        return self.__PWMOutputs