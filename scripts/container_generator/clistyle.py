"""Module for CLI output styling.

This module sets the style of the CLI output
"""

class CLIStyle(object):
    """Class for styling CLI output

    This class defines some constants for styling the output of CLI-Scripts
    To use this class, simply use the constants in your print() functions.
    e.g.: print(CLIStyle.COLOR_GREEN + "Hello World" + CLIStyle.STYLE_RESET)
    """

    STYLE_RESET = '\033[0m'
    CLEAR_SCREEN = '\033[2J'

    STYLE_BOLD = '\033[1m'
    STYLE_UNDERLINE = '\033[4m'

    COLOR_GREEN = '\033[32m'
    COLOR_RED = '\033[31m'
    COLOR_YELLOW = '\033[33m'

    META_H1 = CLEAR_SCREEN + STYLE_RESET + STYLE_BOLD + STYLE_UNDERLINE
    META_OK = COLOR_GREEN
    META_ERR = COLOR_RED
    META_INPUT = COLOR_YELLOW
