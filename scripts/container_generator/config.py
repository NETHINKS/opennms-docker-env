"""
Config module
This module defines the class for getting configuration options
:license: MIT, see LICENSE for more details
:copyright: (c) 2016 by NETHINKS GmbH, see AUTORS for more details
"""

import os
import configparser

class AppConfig(object):

    def __init__(self, config_file=None):
        # get directory name
        basedir = os.path.dirname(os.path.abspath(__file__))
        self.__filename_input = basedir + "/etc/app-default.conf"
        self.__filename_output = basedir + "/output/app-config.conf"
        if config_file is not None:
            self.__filename_input = config_file
        self.__config = configparser.ConfigParser()
        self.__config.read(self.__filename_input)

    def get_value(self, section_name, key, default_value):
        # set default value
        output = default_value

        # get value from config
        try:
            output = self.__config.get(section_name, key)
        except:
            pass

        # return value
        return output

    def get_value_boolean(self, section_name, key):
        output = False
        try:
            output = self.__config.getboolean(section_name, key)
        except:
            pass
        return output

    def get_sections(self):
        return self.__config.sections()

    def get_keys(self, section):
        return self.__config.options(section)

    def set_value(self, section_name, key, value):
        # set value in data structure
        try:
            self.__config[section_name]
        except:
            self.__config[section_name] = {}
        self.__config[section_name][key] = value

        # save configuration file
        with open(self.__filename_output, 'w') as configfile:
            self.__config.write(configfile)
