"""Setup module

This module provides some classes for creating a setup for the generated
environment.
"""
import os
import stat
from template_engine import TemplateEngine

class SetupScript(object):
    """Class for generating a setup script.

    This class generates a setup script with the given informations.

    Attributes:
        filename: output filename
    """

    def __init__(self, filename):
        """Initialization method"""
        self.__filename = filename
        self.__images = []
        self.__setup_scripts = []

    def add_docker_image_setup(self, image_filenames):
        """Add docker image files to setup
        
        Args:
            image_filenames: list with filenames of saved Docker images
        """
        self.__images = image_filenames

    def add_setup_script(self, setup_script_data):
        """Add additional setup scripts (as string)

        Args:
            setup_script_data: string with setup script data
        """
        self.__setup_scripts.append(setup_script_data)

    def generate_setup(self):
        """Create the setup script"""
        template_engine = TemplateEngine()
        template_context = {}
        template_context["scripts"] = self.__setup_scripts
        template_context["images"] = self.__images
        with open(self.__filename, "w") as script_file:
            script_file.write(template_engine.render_template("templates/setup/setup.sh.tpl",
                                                              template_context))
        os.chmod(self.__filename, stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH | stat.S_IRUSR | 
                 stat.S_IRGRP | stat.S_IROTH | stat.S_IWUSR | stat.S_IWGRP)
