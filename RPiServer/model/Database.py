__author__ = 'Sony'

from json import loads, dumps

class Database():
    def __init__(self, path):
        """
        :param path: string
        """

        self.__onDimChanged = lambda a: a
        self.__path = "".join((path, ".txt"))
        try:
            self.__data = self.__read_DB()

        except:
            self.__data = {}
            self.__write_DB(self.__data)

    @property
    def data(self):
        """
        :return: dict
        """

        return self.__data

    @data.setter
    def data(self, value):
        """
        :param value: dict
        """

        self.__data = value

    def save(self):
        self.__write_DB(self.__data)

    def __write_DB(self, content):
        """
        :param content: dict
        """

        DB = open(self.__path, "w")
        DB.write(dumps(content))
        DB.close()

    def __read_DB(self):
        """
        :return: dict
        """

        try:
            DB = open(self.__path, "r")
            result = loads(DB.read())
            DB.close()
        except FileNotFoundError:
            return loads("{}")
        return result
