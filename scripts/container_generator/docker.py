"""Docker module

This module includes classes for docker
"""
import subprocess
import yaml

class DockerImage(object):
    """Representation of a Docker Image

    This class represents a Docker Image

    Attributes:
        image_name: name of the image
    """

    def __init__(self, image_name):
        """Create a new instance"""
        self.__image_name = image_name

    def export_image(self, output_filename):
        """Exports a the image to the given filename

        Args:
            output_filename: filename for the output of the image
        """
        # download image from Docker Hub
        command = ["docker", "pull", self.__image_name]
        subprocess.check_call(command)
        # export image
        command = ["docker", "save", "-o", output_filename, self.__image_name]
        subprocess.check_call(command)

class DockerComposeConfig(object):
    """Representation of the docker-compose.yml config

    This class is a representation of the configuration for docker-compose.yml
    It consists of multiple DockerServiceConfig objects.

    Usage:
        config = DockerComposeConfig
        config.add_service(docker_service_1)
        config.add_service(docker_service_2)
        config.add_network(docker_network_1)
        config.add_volume(docker_volume_1)
        config.create_yaml_output()
    """

    def __init__(self):
        """Create a new instance"""
        self.__docker_services = []
        self.__docker_networks = []
        self.__docker_volumes = []

    def add_service(self, docker_service_config):
        """Adds a new DockerServiceConfig object

        Args:
            docker_service_config: the new DockerServiceConfig object

        Returns:
            None
        """
        self.__docker_services.append(docker_service_config)

    def add_network(self, docker_network_config):
        """Adds a new DockerNetworkConfig object

        Args:
            docker_network_config: the new DockerNetworkConfig object

        Returns:
            None
        """
        self.__docker_networks.append(docker_network_config)

    def add_volumes(self, volumenames):
        """Adds a list of named volumes to declare

        Args:
            volumenames: list with names of named volumes

        Returns:
            None
        """
        self.__docker_volumes = list(set(self.__docker_volumes + volumenames))

    def create_yaml_output(self):
        """Creates YAML output for docker-compose.yml

        This function creates the output for docker-compose.xml for the given
        DockerService objects

        Returns:
            String with YAML output for docker-compose.yml
        """
        yaml_data = {}
        yaml_data["version"] = "2.1"
        yaml_data["services"] = {}
        yaml_data["networks"] = {}
        yaml_data["volumes"] = {}
        for docker_service in self.__docker_services:
            docker_service_name = docker_service.get_name()
            docker_service_config = docker_service.get_config_dict()
            yaml_data["services"][docker_service_name] = docker_service_config
        for docker_network in self.__docker_networks:
            docker_network_name = docker_network.get_name()
            docker_network_config = docker_network.get_config_dict()
            yaml_data["networks"][docker_network_name] = docker_network_config
        for docker_volume in self.__docker_volumes:
            yaml_data["volumes"][docker_volume] = {}
        return yaml.safe_dump(yaml_data, default_flow_style=False)

class DockerServiceConfig(object):
    """Representation of a docker service configuration

    This class represents the configuration of a docker service configuration

    Attributes:
        name: name of the container
    """

    def __init__(self, name):
        """Initialization"""
        self.__name = name
        self.__image = ""
        self.__dependencies = []
        self.__volumes = []
        self.__ports = []
        self.__environment = {}
        self.__buildargs = {}
        self.__privileged = False
        self.__restart_policy = "no"
        self.__build = None
        self.__network_mode = None

    def get_name(self):
        """Returns the container name"""
        return self.__name

    def get_image(self):
        """Returns the image name"""
        return self.__image

    def set_image(self, image):
        """Sets the image of the container

        Args:
            image: the image name of the container
        """
        self.__image = image

    def set_privileged(self, privileged):
        """Sets if the container is privileged

        Args:
            privileged: boolean flag, if it is a privileged container
        """
        self.__privileged = privileged

    def set_restart_policy(self, policy):
        """Sets the containers restart policy

        Args:
            policy: String with restart policy
        """
        self.__restart_policy = policy

    def add_dependency(self, target):
        """Adds a dependency  to another container

        Args:
            target: target container name
        """
        self.__dependencies.append(target)

    def add_volume(self, volume_definition):
        """Adds a volume definition.

        Args:
            volume_definition: Docker volume definition
        """
        self.__volumes.append(volume_definition)

    def add_port(self, port_definition):
        """Adds a port definition.

        Args:
            port_definition: Docker port definition
        """
        self.__ports.append(port_definition)

    def add_environment(self, env_variable, env_value):
        """Adds an environment variable

        Args:
            env_variable: name of the environment variable
            env_value: value of the environment variable
        """
        self.__environment[env_variable] = env_value

    def add_buildarg(self, arg, value):
        """Adds a build argument

        Args:
            arg: name of the build argument
            value: value of the build argument
        """
        self.__buildargs[arg] = value

    def set_build_path(self, build_path):
        """Sets the build option with the given path

        Args:
            build_path: path to Dockerfile
        """
        self.__build = build_path

    def set_network_mode(self, network_mode):
        """Sets the network_mode

        Args:
            network_mode: Docker Compose network mode option
        """
        self.__network_mode = network_mode

    def get_config_dict(self):
        """get the configuration as dict

        Returns the docker service configuration as dict
        """
        output = {}
        output["image"] = self.__image
        output["depends_on"] = self.__dependencies
        output["privileged"] = self.__privileged
        output["restart"] = self.__restart_policy
        output["environment"] = self.__environment
        output["volumes"] = self.__volumes
        output["ports"] = self.__ports
        if self.__build:
            output["build"] = {}
            output["build"]["context"] = self.__build
            if self.__buildargs:
                output["build"]["args"] = self.__buildargs
        if self.__network_mode:
            output["network_mode"] = self.__network_mode
        return output

class DockerNetworkConfig(object):

    def __init__(self, name):
        """Initialization"""
        self.__name = name
        self.__ipam_config = []
        self.__ipv6_enable = None
        self.__driver = None
        self.__driver_opts = {}

    def get_name(self):
        """Returns the container name"""
        return self.__name

    def add_ip_config(self, network, gateway=None):
        ip_config = {}
        ip_config["subnet"] = network
        if gateway is not None:
            ip_config["gateway"] = gateway
        self.__ipam_config.append(ip_config)

    def set_ipv6_enable(self, ipv6_enable):
        self.__ipv6_enable = ipv6_enable

    def set_driver(self, driver):
        self.__driver = driver

    def set_driver_opts(self, driver_opts):
        self.__driver_opts = driver_opts

    def get_config_dict(self):
        """get the configuration as dict

        Returns the docker network configuration as dict
        """
        output = {}
        if self.__ipv6_enable:
            output["enable_ipv6"] = self.__ipv6_enable
        if self.__driver:
            output["driver"] = self.__driver
        if self.__driver_opts:
            output["driver_opts"] = self.__driver_opts
        if self.__ipam_config:
            output["ipam"] = {}
            output["ipam"]["config"] = self.__ipam_config
        return output
