from datetime import time

__author__ = 'Sony'
from time import strftime

class Scheduler():
    def __init__(self, raw_DB, dim_setter, broadcast_function):
        """
        :param raw_DB: dict
        """
        self.__raw_DB = raw_DB
        self.__dim_setter = dim_setter
        self.__broadcast_function = broadcast_function

    def __parse_time(self):
        """
        :return: string
        """

        actual_time = strftime("%H:%M")
        hour = int(actual_time.split(":")[0])
        minute = int(actual_time.split(":")[1])

        return str(hour * 100 + minute)

    def __parse_from_DB(self):
        """
        :return: dict
        """
        schedule = dict()

        for k, v in self.__raw_DB.items():
            schedule[k] = v["schedule"]

        return schedule

    def check(self):
        whole_schedule = self.__parse_from_DB()
        timeIndex = self.__parse_time()

        for pin, schedules in whole_schedule.items():
            if timeIndex in schedules.keys():
                self.__dim_setter(int(pin), whole_schedule[pin][timeIndex])
                self.__broadcast_function(int(pin))