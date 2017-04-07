"""Module for getting required software

This module downloads the required software for the environment
"""
import os
import requests
from template_engine import TemplateEngine

class Software(object):

    name = "Software"

    def __init__(self, output_basedir):
        self._output_basedir = output_basedir + "/software"

    def get_software(self):
        pass

    def get_name(self):
        return type(self).name

    def get_setup(self):
        return ""


class DockerEngine(Software):

    name = "docker-engine"
    software_url = "https://get.docker.com/builds/Linux/x86_64/docker-17.03.1-ce.tgz"

    def get_software(self):
        response = requests.get(DockerEngine.software_url)
        if response.status_code != 200:
            raise Exception("could not download docker-engine")

        # create output directories if not exist
        output_dir = self._output_basedir + "/docker-engine"
        os.makedirs(output_dir, exist_ok=True)

        # write docker-compose file
        bin_file_name = output_dir + "/docker-engine.tar.gz"
        with open(bin_file_name, "wb") as bin_file:
            bin_file.write(response.content)

    def get_setup(self):
        context = {}
        template_engine = TemplateEngine()
        setup_data = template_engine.render_template("templates/software/docker-engine-setup.sh.tpl",
                                                     context)
        return setup_data


class DockerCompose(Software):

    name = "docker-compose"
    software_url = "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-Linux-x86_64"

    def get_software(self):
        response = requests.get(DockerCompose.software_url)
        if response.status_code != 200:
            raise Exception("could not download docker-compose")

        # create output directories if not exist
        output_dir = self._output_basedir + "/docker-compose"
        os.makedirs(output_dir, exist_ok=True)

        # write docker-compose file
        bin_file_name = output_dir + "/docker-compose"
        with open(bin_file_name, "wb") as bin_file:
            bin_file.write(response.content)

    def get_setup(self):
        context = {}
        template_engine = TemplateEngine()
        setup_data = template_engine.render_template("templates/software/docker-compose-setup.sh.tpl",
                                                     context)
        return setup_data
