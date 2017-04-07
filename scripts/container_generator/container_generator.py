#!/usr/bin/python3
"""container_generator main module.

This is the main module of container_generator.
To start container_generator, simply execute this file.
"""
import argparse
import os
import shutil
import software
from collections import OrderedDict
from config import AppConfig
from container import OpenNMS
from container import Cassandra
from container import PostgreSQL
from container import Nginx
from container import Grafana
from container import Management
from container import AlarmForwarder
from container import YourDashboard
from container import Pris
from container import IPv6Helper
from docker import DockerComposeConfig
from docker import DockerNetworkConfig
from clistyle import CLIStyle
from setup import SetupScript

def main():
    """main function"""

    # status variable for error handling (0 = OK, 1 = ERROR)
    status = 0

    # parse arguments
    argparser = argparse.ArgumentParser()
    argparser.add_argument("-c", "--config", dest="config_file", help="app configuration file")
    arguments = argparser.parse_args()

    # output headline
    print(CLIStyle.META_H1 + "OpenNMS Docker Container Setup" + CLIStyle.STYLE_RESET)
    print("\n\n")

    # define config options
    basedir = os.path.dirname(__file__)
    config_dir_output = basedir + "/output"

    # clear output dir
    try:
        shutil.rmtree(config_dir_output, ignore_errors=False)
    except:
        pass
    os.makedirs(config_dir_output, exist_ok=True)

    # get configuration
    app_config = AppConfig(arguments.config_file)


    # ask parameters if no config file is given
    if arguments.config_file is None:
        for config_section in app_config.get_sections():
            print("[" + config_section + "]")
            for config_key in app_config.get_keys(config_section):
                config_default_value = app_config.get_value(config_section, config_key, "")
                input_prompt = config_key
                input_prompt += "[" + CLIStyle.META_INPUT
                input_prompt += config_default_value
                input_prompt += CLIStyle.STYLE_RESET + "]: "
                input_value = input(input_prompt)
                if input_value != "":
                    app_config.set_value(config_section, config_key, input_value)
            print("\n\n")

    # register required software
    software_entries = [
        software.DockerCompose(config_dir_output),
        software.DockerEngine(config_dir_output)
    ]

    # stores for container parameters, proxy locations and container config
    proxy_locations = []
    docker_compose_config = DockerComposeConfig()

    # register available containers in correct order to resolve
    # dependencies
    containers = OrderedDict()
    containers["postgres"] = PostgreSQL("postgres", config_dir_output, app_config)
    containers["opennms"] = OpenNMS("opennms", config_dir_output, app_config)
    containers["management"] = Management("management", config_dir_output, app_config)
    if app_config.get_value_boolean("container", "cassandra"):
        containers["cassandra"] = Cassandra("cassandra", config_dir_output, app_config)
    if app_config.get_value_boolean("container", "grafana"):
        containers["grafana"] = Grafana("grafana", config_dir_output, app_config)
    if app_config.get_value_boolean("container", "alarmforwarder"):
        containers["alarmforwarder"] = AlarmForwarder("alarmforwarder", config_dir_output, app_config)
    if app_config.get_value_boolean("container", "yourdashboard"):
        containers["yourdashboard"] = YourDashboard("yourdashboard", config_dir_output, app_config)
    if app_config.get_value_boolean("container", "pris"):
        containers["pris"] = Pris("pris", config_dir_output, app_config)
    if app_config.get_value_boolean("network", "ipv6_support"):
        containers["ipv6helper"] = IPv6Helper("ipv6helper", config_dir_output, app_config)
    # must be the last one, to generate the proxy configuration for all containers
    if app_config.get_value_boolean("container", "proxy"):
        containers["nginx"] = Nginx("nginx", config_dir_output, app_config)


    print("create environment...")

    # setup all containers
    for container_name in containers:
        container = containers[container_name]
        # special handling for special containers
        if container_name == "nginx":
            container.set_proxy_locations(proxy_locations)

        print("create container " + container.get_name() + "...")
        container.setup_container()
        proxy_locations.extend(container.get_proxy_locations())

    # get container config and generate docker-compose.yml
    print("create docker-compose.yml...")
    for container_name in containers:
        container = containers[container_name]
        docker_compose_config.add_service(container.get_container_config())
        docker_compose_config.add_volumes(container.get_named_volumes())
    docker_network = DockerNetworkConfig("default")
    docker_network.set_driver("bridge")
    docker_network_driver_opts = {}
    docker_network_driver_opts["com.docker.network.bridge.name"] = app_config.get_value("network", "bridge_interface_name", "")
    docker_network.set_driver_opts(docker_network_driver_opts)
    docker_network.add_ip_config(app_config.get_value("network", "ipv4_internal_net", ""))
    if app_config.get_value_boolean("network", "ipv6_support"):
        docker_network.set_ipv6_enable(True)
        docker_network.add_ip_config(app_config.get_value("network", "ipv6_internal_net", ""))
    docker_compose_config.add_network(docker_network)
    docker_compose_filename = config_dir_output + "/docker-compose.yml"
    with open(docker_compose_filename, "w") as docker_compose_file:
        docker_compose_file.write(docker_compose_config.create_yaml_output())
    print("\n")

    # download images if required
    if app_config.get_value_boolean("setup", "download_images"):
        for container_name in containers:
            container = containers[container_name]
            print("download image for container " + container.get_name() + "...")
            try:
                container.download_image()
                print(CLIStyle.META_OK + "[OK]" + CLIStyle.STYLE_RESET)
            except:
                print(CLIStyle.META_ERR + "[ERROR]" + CLIStyle.STYLE_RESET)
                status = 1
            print("\n")
        print("\n")

    # download software if required
    if app_config.get_value_boolean("setup", "download_software"):
        for software_entry in software_entries:
            print("download software " + software_entry.get_name())
            try:
                software_entry.get_software()
                print(CLIStyle.META_OK + "[OK]" + CLIStyle.STYLE_RESET)
            except:
                print(CLIStyle.META_ERR + "[ERROR]" + CLIStyle.STYLE_RESET)
                status = 1
            print("\n")
        print("\n")

    # create setup script
    if (app_config.get_value_boolean("setup", "download_software") or 
        app_config.get_value_boolean("setup", "download_images")):
        print("create setup.sh")
        setup_script = SetupScript(config_dir_output + "/setup.sh")
        if app_config.get_value_boolean("setup", "download_images"):
            setup_images = []
            for container_name in containers:
                container = containers[container_name]
                setup_images.append(container.get_image_filename())
            setup_script.add_docker_image_setup(setup_images)
        if app_config.get_value_boolean("setup", "download_software"):
            for software_entry in software_entries:
                setup_script.add_setup_script(software_entry.get_setup())
        setup_script.generate_setup()

    # check status
    if status == 0:
        print(CLIStyle.META_OK + "Finished creating Docker environment :-)")
    else:
        print(CLIStyle.META_ERR + "Finished creating Docker environment with errors :-(")
    print(CLIStyle.STYLE_RESET)

if __name__ == '__main__':
    main()
