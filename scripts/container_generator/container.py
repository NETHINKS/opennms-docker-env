""" Container module.

This module defines the container definitions for container_generator.
"""
import os
import time
import hashlib
from collections import OrderedDict
from OpenSSL import crypto
from template_engine import TemplateEngine
from docker import DockerImage
from docker import DockerServiceConfig

class Container(object):
    """Abstract definition of a container

    This class represents an abstract definition of a container. It should not
    be used directly. Instead a subclass which extends this class should be
    used.

    Attributes:
        container_name: unique name of the container
        output_basedir: base directory for output data

    Usage:
        A subclass of this should at first be initialized with __init__().
        The method get_default_parameters() returns all parameters for a
        container with default values. After that, the setup_container() method
        creates all configuration and files needed for the specific container.
    """

    default_parameters = OrderedDict()

    def __init__(self, container_name, output_basedir, app_config):
        """Initialization method"""
        self._container_name = container_name
        self._container_parameters = OrderedDict()
        self._container_proxylocations = []
        self._container_outputdir = output_basedir + "/init/" + container_name
        self._container_imagedir = output_basedir + "/images/"
        self._container_imagename = self._container_name + ".tar"
        self._container_namedvolumes = []
        self._container_config = DockerServiceConfig(container_name)
        self._app_config = app_config

        # create output directories if not exist
        os.makedirs(self._container_outputdir, exist_ok=True)

        # init with default_parameters
        self._container_parameters = type(self).default_parameters

    def get_name(self):
        """Returns the container name"""
        return self._container_name

    def get_image_filename(self):
        """Returns the filename for the stored image"""
        return "images/" + self._container_imagename

    def setup_container(self, parameters):
        """Setup an container

        This method must be implemented by a subclass. The following things
        should be done in this method:
        - setup proxy locations in self._container_proxylocations
        - create container config in self._container_config

        Args:
            parameters: parameters for the container
        """
        pass

    def get_container_config(self):
        """Return the container config

        Return:
            The container config as DockerServiceConfig object
        """
        return self._container_config

    def get_proxy_locations(self):
        """Return all proxy locations that should be created for this one"""
        return self._container_proxylocations

    def get_named_volumes(self):
        """Return a list with all configured named volumes"""
        return self._container_namedvolumes

    def download_image(self):
        # create image dir if not exist
        os.makedirs(self._container_imagedir, exist_ok=True)
        image_name = self._container_config.get_image()
        output_filename = self._container_imagedir + self._container_imagename
        docker_image = DockerImage(image_name)
        docker_image.export_image(output_filename)


class OpenNMS(Container):
    """Class for defining a container for OpenNMS

    Please see documentation of class Container for more details
    """

    default_parameters = OrderedDict([
        ("database_server", "postgres"),
        ("database_user", "postgres"),
        ("database_password", "secret1234"),
        ("user_admin_password", "admin"),
        ("user_api_password", "api"),
        ("cassandra_server", "cassandra"),
        ("cassandra_user", "cassandra"),
        ("cassandra_password", "secret1234")
    ])

    def __init__(self, container_name, output_basedir, app_config):
        """Initialization method"""
        Container.__init__(self, container_name, output_basedir, app_config)
        self._container_parameters["database_password"] = self._app_config.get_value("authentication", "db_password", "")
        self._container_parameters["cassandra_password"] = self._app_config.get_value("authentication", "db_password", "")
        self._container_parameters["user_admin_password"] = self._app_config.get_value("authentication", "admin_password", "")
        self._container_parameters["user_api_password"] = self._app_config.get_value("authentication", "api_password", "")

    def setup_container(self):
        # setup proxy locations
        self._container_proxylocations = [{
            "name": "OpenNMS",
            "location": "/opennms",
            "url": "http://opennms:8980"
        }]
        
        # container config
        self._container_config.set_image("nethinks/opennmsenv-opennms:18.0.4-2")
        if self._app_config.get_value_boolean("setup", "build_images"):
            self._container_config.set_build_path("../../../images/opennms")
            self._container_config.add_buildarg("build_customrepo", "https://opennmsdeploy.nethinks.com/repo/horizon/18.0.4/")
        self._container_config.set_privileged(True)
        self._container_config.set_restart_policy("always")
        self._container_config.add_environment("INIT_DB_SERVER",
                                               self._container_parameters["database_server"])
        self._container_config.add_environment("INIT_DB_USER",
                                               self._container_parameters["database_user"])
        self._container_config.add_environment("INIT_DB_PASSWORD",
                                               self._container_parameters["database_password"])
        self._container_config.add_environment("INIT_ADMIN_USER", "admin")
        self._container_config.add_environment("INIT_ADMIN_PASSWORD",
                                                self._container_parameters["user_admin_password"])
        self._container_config.add_environment("INIT_API_USER", "admin")
        self._container_config.add_environment("INIT_API_PASSWORD",
                                                self._container_parameters["user_api_password"])
        self._container_namedvolumes.append("opennms")
        self._container_namedvolumes.append("rrd")
        self._container_config.add_volume("opennms:/data/container")
        self._container_config.add_volume("rrd:/data/rrd")
        self._container_config.add_volume("export:/data/export")
        self._container_config.add_volume("./init/opennms:/data/init")
        self._container_config.add_port("162/udp:162/udp")
        self._container_config.add_port("514/udp:514/udp")
        self._container_config.add_port("5817:5817")
        self._container_config.add_dependency("postgres")

        # check cassandra option and parameters
        if self._app_config.get_value_boolean("container", "cassandra"):
            self._container_config.add_environment("INIT_CASSANDRA_ENABLE", "true")
            self._container_config.add_environment("INIT_CASSANDRA_SERVER",
                                                   self._container_parameters["cassandra_server"])
            self._container_config.add_environment("INIT_CASSANDRA_USER",
                                                   self._container_parameters["cassandra_user"])
            self._container_config.add_environment("INIT_CASSANDRA_PASSWORD",
                                                   self._container_parameters["cassandra_password"])
            self._container_config.add_dependency("cassandra")


class PostgreSQL(Container):
    """Class for defining a container for PostgreSQL

    Please see documentation of class Container for more details
    """

    default_parameters = OrderedDict([
        ("database_user", "postgres"),
        ("database_password", "secret1234")
    ])

    def __init__(self, container_name, output_basedir, app_config):
        """Initialization method"""
        Container.__init__(self, container_name, output_basedir, app_config)
        self._container_parameters["database_password"] = self._app_config.get_value("authentication", "db_password", "")

    def setup_container(self):
        # container config
        self._container_config.set_image("nethinks/opennmsenv-postgres:9.5.3-1")
        if self._app_config.get_value_boolean("setup", "build_images"):
            self._container_config.set_build_path("../../../images/postgres")
        self._container_config.set_restart_policy("always")
        self._container_config.add_environment("POSTGRES_USER",
                                               self._container_parameters["database_user"])
        self._container_config.add_environment("POSTGRES_PASSWORD",
                                               self._container_parameters["database_password"])
        self._container_namedvolumes.append("postgres")
        self._container_config.add_volume("postgres:/data/container")
        self._container_config.add_volume("export:/data/export")
        self._container_config.add_volume("./init/postgres:/data/init")


class Cassandra(Container):
    """Class for defining a container for Newts/Cassandra

    Please see documentation of class Container for more details
    """

    default_parameters = OrderedDict([
        ("cassandra_user", "cassandra"),
        ("cassandra_password", "secret1234")
    ])

    def __init__(self, container_name, output_basedir, app_config):
        """Initialization method"""
        Container.__init__(self, container_name, output_basedir, app_config)
        self._container_parameters["cassandra_password"] = self._app_config.get_value("authentication", "db_password", "secret1234")

    def setup_container(self):
        # container config
        self._container_config.set_image("nethinks/opennmsenv-cassandra:3.10-1")
        if self._app_config.get_value_boolean("setup", "build_images"):
            self._container_config.set_build_path("../../../images/cassandra")
        self._container_config.set_restart_policy("always")
        self._container_config.add_environment("CASSANDRA_USER",
                                               self._container_parameters["cassandra_user"])
        self._container_config.add_environment("CASSANDRA_PASSWORD",
                                               self._container_parameters["cassandra_password"])
        self._container_namedvolumes.append("cassandra")
        self._container_config.add_volume("cassandra:/data/container")
        self._container_config.add_volume("export:/data/export")
        self._container_config.add_volume("./init/cassandra:/data/init")


class Nginx(Container):
    """Class for defining a container for Nginx

    Please see documentation of class Container for more details
    """

    default_parameters = OrderedDict([
        ("ssl_organisation", "NETHINKS GmbH"),
        ("ssl_unit", "PSS"),
        ("ssl_country", "DE"),
        ("ssl_state", "HESSEN"),
        ("ssl_location", "Fulda"),
        ("ssl_cn", "localhost"),
        ("ssl_valid_time_days", "3650"),
        ("ssl_keylength", "4096"),
        ("ssl_digest", "sha384")
    ])

    def __init__(self, container_name, output_basedir, app_config):
        """Initialization method"""
        Container.__init__(self, container_name, output_basedir, app_config)
        self._container_parameters["ssl_organisation"] = self._app_config.get_value("ssl", "organisation", "")
        self._container_parameters["ssl_unit"] = self._app_config.get_value("ssl", "unit", "")
        self._container_parameters["ssl_country"] = self._app_config.get_value("ssl", "country", "")
        self._container_parameters["ssl_state"] = self._app_config.get_value("ssl", "state", "")
        self._container_parameters["ssl_location"] = self._app_config.get_value("ssl", "location", "")
        self._container_parameters["ssl_cn"] = self._app_config.get_value("ssl", "cn", "")
        self._container_parameters["ssl_valid_time_days"] = self._app_config.get_value("ssl", "valid_time_days", "")
        self._container_parameters["ssl_keylength"] = self._app_config.get_value("ssl", "keylength", "")
        self._container_parameters["ssl_digest"] = self._app_config.get_value("ssl", "digest", "")
        self._container_parameters["support_text"] = self._app_config.get_value("supportinfo", "support_text", "")
        self.__proxy_locations = []

    def setup_container(self):
        # container config
        self._container_config.set_image("nethinks/opennmsenv-nginx:1.10.2-1")
        if self._app_config.get_value_boolean("setup", "build_images"):
            self._container_config.set_build_path("../../../images/nginx")
        self._container_config.set_restart_policy("always")
        self._container_config.add_port("80:80")
        self._container_config.add_port("443:443")
        self._container_namedvolumes.append("nginx")
        self._container_config.add_volume("nginx:/data/container")
        self._container_config.add_volume("export:/data/export")
        self._container_config.add_volume("./init/nginx:/data/init")

        # create nginx.conf
        template_engine = TemplateEngine()
        template_context = {}
        template_context["locations"] = self.__proxy_locations
        for location in template_context["locations"]:
            if location["location"].endswith("/"):
                location["trailing_slash"] = True
                location["url"] = location["url"].rstrip("/")
        config_file_dir = self._container_outputdir + "/etc"
        os.makedirs(config_file_dir, exist_ok=True)
        config_file_name = config_file_dir + "/nginx.conf"
        template_engine.render_template_to_file("templates/container/nginx/nginx.conf.tpl",
                                                config_file_name, template_context)

        # create SSL key, certificate and CSR
        ssl_key = crypto.PKey()
        ssl_key.generate_key(crypto.TYPE_RSA, int(self._container_parameters["ssl_keylength"]))

        ssl_csr = crypto.X509Req()
        ssl_csr.get_subject().C = self._container_parameters["ssl_country"]
        ssl_csr.get_subject().ST = self._container_parameters["ssl_state"]
        ssl_csr.get_subject().L = self._container_parameters["ssl_location"]
        ssl_csr.get_subject().O = self._container_parameters["ssl_organisation"]
        ssl_csr.get_subject().OU = self._container_parameters["ssl_unit"]
        ssl_csr.get_subject().CN = self._container_parameters["ssl_cn"]
        ssl_csr.set_pubkey(ssl_key)
        ssl_csr.sign(ssl_key, self._container_parameters["ssl_digest"])

        ssl_certificate = crypto.X509()
        ssl_certificate.get_subject().C = self._container_parameters["ssl_country"]
        ssl_certificate.get_subject().ST = self._container_parameters["ssl_state"]
        ssl_certificate.get_subject().L = self._container_parameters["ssl_location"]
        ssl_certificate.get_subject().O = self._container_parameters["ssl_organisation"]
        ssl_certificate.get_subject().OU = self._container_parameters["ssl_unit"]
        ssl_certificate.get_subject().CN = self._container_parameters["ssl_cn"]
        ssl_certificate.gmtime_adj_notBefore(0)
        ssl_certificate.gmtime_adj_notAfter(int(self._container_parameters["ssl_valid_time_days"])
                                            * 24 * 60 * 60)
        ssl_certificate.set_pubkey(ssl_key)
        ssl_certificate.set_issuer(ssl_certificate.get_subject())
        ssl_certificate.set_serial_number(int(time.time()))
        ssl_certificate.sign(ssl_key, self._container_parameters["ssl_digest"])

        sslcsr_file_name = config_file_dir + "/proxy.csr"
        sslcert_file_name = config_file_dir + "/proxy.crt"
        sslkey_file_name = config_file_dir + "/proxy.key"
        with open(sslcsr_file_name, "wb") as sslcsr_file:
            sslcsr_file.write(crypto.dump_certificate_request(crypto.FILETYPE_PEM,
                                                              ssl_csr))
        with open(sslcert_file_name, "wb") as sslcert_file:
            sslcert_file.write(crypto.dump_certificate(crypto.FILETYPE_PEM,
                                                       ssl_certificate))
        with open(sslkey_file_name, "wb") as sslkey_file:
            sslkey_file.write(crypto.dump_privatekey(crypto.FILETYPE_PEM, ssl_key))

        # create website with support infos
        template_engine = TemplateEngine()
        template_context = {}
        template_context["locations"] = self.__proxy_locations
        template_context["parameters"] = self._container_parameters
        web_file_dir = self._container_outputdir + "/www/start"
        template_engine.render_directory("templates/container/nginx/www/start", web_file_dir, template_context)

    def set_proxy_locations(self, proxy_locations):
        """Method for adding proxy locations

        This method must be executed before the setup_container() method
        """
        self.__proxy_locations.extend(proxy_locations)

class Grafana(Container):
    """Class for defining a container for Grafana

    Please see documentation of class Container for more details
    """

    default_parameters = OrderedDict([
        ("admin_password", "admin"),
        ("opennms_url", "http://opennms:8980/opennms"),
        ("opennms_username", "admin"),
        ("opennms_password", "admin")
    ])

    def __init__(self, container_name, output_basedir, app_config):
        """Initialization method"""
        Container.__init__(self, container_name, output_basedir, app_config)
        self._container_parameters["admin_password"] = self._app_config.get_value("authentication", "admin_password", "")
        self._container_parameters["opennms_username"] = "api"
        self._container_parameters["opennms_password"] = self._app_config.get_value("authentication", "api_password", "")

    def setup_container(self):
        # setup proxy locations
        self._container_proxylocations = [{
            "name": "Grafana",
            "location": "/grafana/",
            "url": "http://grafana:3000/"
        }]

        # container config
        self._container_config.set_image("nethinks/opennmsenv-grafana:3.1.1-1")
        if self._app_config.get_value_boolean("setup", "build_images"):
            self._container_config.set_build_path("../../../images/grafana")
        self._container_config.set_restart_policy("always")
        self._container_config.add_environment("ADMIN_PASSWORD",
                                               self._container_parameters["admin_password"])
        self._container_config.add_environment("ONMS_URL",
                                               self._container_parameters["opennms_url"])
        self._container_config.add_environment("ONMS_USER",
                                               self._container_parameters["opennms_username"])
        self._container_config.add_environment("ONMS_PASSWORD",
                                               self._container_parameters["opennms_password"])
        self._container_namedvolumes.append("grafana")
        self._container_config.add_volume("grafana:/data/container")
        self._container_config.add_volume("export:/data/export")
        self._container_config.add_volume("./init/grafana:/data/init")


class AlarmForwarder(Container):
    """Class for defining a container for Alarmforwarder

    Please see documentation of class Container for more details
    """

    default_parameters = OrderedDict([
        ("admin_password", "admin"),
        ("opennms_url", "http://opennms:8980/opennms/rest"),
        ("opennms_username", "admin"),
        ("opennms_password", "admin"),
        ("db_server", "postgres"),
        ("db_name", "alarmforwarder"),
        ("db_user", "postgres"),
        ("db_password", "postgres")
    ])

    def __init__(self, container_name, output_basedir, app_config):
        """Initialization method"""
        Container.__init__(self, container_name, output_basedir, app_config)
        self._container_parameters["admin_password"] = self._app_config.get_value("authentication", "admin_password", "")
        self._container_parameters["opennms_username"] = "api"
        self._container_parameters["opennms_password"] = self._app_config.get_value("authentication", "api_password", "")
        self._container_parameters["db_password"] = self._app_config.get_value("authentication", "db_password", "")

    def setup_container(self):
        # setup proxy locations
        self._container_proxylocations = [{
            "name": "AlarmForwarder",
            "location": "/alarmforwarder/",
            "url": "http://alarmforwarder:5000/"
        }]

        # container config
        self._container_config.set_image("nethinks/opennmsenv-alarmforwarder:1.0.1-1")
        if self._app_config.get_value_boolean("setup", "build_images"):
            self._container_config.set_build_path("../../../images/alarmforwarder")
        self._container_config.set_restart_policy("always")
        self._container_config.add_environment("ADMIN_PASSWORD",
                                               self._container_parameters["admin_password"])
        self._container_config.add_environment("DB_SERVER",
                                               self._container_parameters["db_server"])
        self._container_config.add_environment("DB_NAME",
                                               self._container_parameters["db_name"])
        self._container_config.add_environment("DB_USER",
                                               self._container_parameters["db_user"])
        self._container_config.add_environment("DB_PASSWORD",
                                               self._container_parameters["db_password"])
        self._container_config.add_environment("ONMS_URL",
                                               self._container_parameters["opennms_url"])
        self._container_config.add_environment("ONMS_USER",
                                               self._container_parameters["opennms_username"])
        self._container_config.add_environment("ONMS_PASSWORD",
                                               self._container_parameters["opennms_password"])
        self._container_namedvolumes.append("alarmforwarder")
        self._container_config.add_volume("alarmforwarder:/data/container")
        self._container_config.add_volume("export:/data/export")
        self._container_config.add_volume("./init/alarmforwarder:/data/init")
        self._container_config.add_dependency("postgres")


class YourDashboard(Container):
    """Class for defining a container for yourDashboard

    Please see documentation of class Container for more details
    """

    default_parameters = OrderedDict([
        ("opennms_url", "http://opennms:8980/opennms/rest"),
        ("opennms_username", "admin"),
        ("opennms_password", "admin")
    ])

    def __init__(self, container_name, output_basedir, app_config):
        """Initialization method"""
        Container.__init__(self, container_name, output_basedir, app_config)
        self._container_parameters["opennms_username"] = "api"
        self._container_parameters["opennms_password"] = self._app_config.get_value("authentication", "api_password", "")

    def setup_container(self):
        # setup proxy locations
        self._container_proxylocations = [{
            "name": "yourDashboard",
            "location": "/yourdashboard",
            "url": "http://yourdashboard"
        }]

        # container config
        self._container_config.set_image("nethinks/opennmsenv-yourdashboard:0.3-1")
        if self._app_config.get_value_boolean("setup", "build_images"):
            self._container_config.set_build_path("../../../images/yourdashboard")
        self._container_config.set_restart_policy("always")
        self._container_namedvolumes.append("yourdashboard")
        self._container_config.add_volume("yourdashboard:/data/container")
        self._container_config.add_volume("export:/data/export")
        self._container_config.add_volume("./init/yourdashboard:/data/init")

        # create dashboard-configuration.xml for yourDashboard
        template_engine = TemplateEngine()
        template_context = {
            "url": self._container_parameters["opennms_url"],
            "user": self._container_parameters["opennms_username"],
            "password": self._container_parameters["opennms_password"]
        }
        config_file_dir = self._container_outputdir + "/etc"
        config_file_name = config_file_dir + "/dashboard-configuration.xml"
        os.makedirs(config_file_dir, exist_ok=True)
        template_engine.render_template_to_file("templates/container/yourdashboard/dashboard-configuration.xml.tpl",
                                                config_file_name, template_context)


class Pris(Container):
    """Class for defining a container for PRIS

    Please see documentation of class Container for more details
    """

    default_parameters = OrderedDict([])

    def __init__(self, container_name, output_basedir, app_config):
        """Initialization method"""
        Container.__init__(self, container_name, output_basedir, app_config)

    def setup_container(self):
        # container config
        self._container_config.set_image("nethinks/opennmsenv-pris:1.1.5-1")
        if self._app_config.get_value_boolean("setup", "build_images"):
            self._container_config.set_build_path("../../../images/pris")
        self._container_config.set_restart_policy("always")
        self._container_namedvolumes.append("pris")
        self._container_config.add_volume("pris:/data/container")
        self._container_config.add_volume("export:/data/export")
        self._container_config.add_volume("./init/pris:/data/init")


class IPv6Helper(Container):
    """Class for defining a container for IPv6Helper

    Please see documentation of class Container for more details
    """

    default_parameters = OrderedDict([
        ("ip6net", "fd00:1::/48"),
        ("bridge_interface", "onmsenv0")
    ])

    def __init__(self, container_name, output_basedir, app_config):
        """Initialization method"""
        Container.__init__(self, container_name, output_basedir, app_config)
        self._container_parameters["ip6net"] = self._app_config.get_value("network", "ipv6_internal_net", "")
        self._container_parameters["bridge_interface"] = self._app_config.get_value("network", "bridge_interface_name", "")

    def setup_container(self):
        # container config
        self._container_config.set_image("nethinks/opennmsenv-ipv6helper:1.0.0-1")
        if self._app_config.get_value_boolean("setup", "build_images"):
            self._container_config.set_build_path("../../../images/ipv6helper")
        self._container_config.set_restart_policy("always")
        self._container_config.set_privileged(True)
        self._container_config.set_network_mode("host")
        self._container_config.add_environment("CONF_IP6NET",
                                               self._container_parameters["ip6net"])
        self._container_config.add_environment("CONF_BRIDGE_INTERFACE",
                                               self._container_parameters["bridge_interface"])
        self._container_config.add_volume("/lib/modules:/lib/modules:ro")
 

class Management(Container):
    """Class for defining a container for management access

    Please see documentation of class Container for more details
    """

    default_parameters = OrderedDict([
        ("ssh_password", "admin"),
        ("backup_enabled", "False"),
        ("backup_url", "smb://username:password@1.2.3.4/backup/test"),
    ])

    def __init__(self, container_name, output_basedir, app_config):
        """Initialization method"""
        Container.__init__(self, container_name, output_basedir, app_config)
        self._container_parameters["ssh_password"] = self._app_config.get_value("authentication", "admin_password", "")
        self._container_parameters["backup_enabled"] = self._app_config.get_value("backup", "enabled", "False")
        self._container_parameters["backup_url"] = self._app_config.get_value("backup", "url", "")

    def setup_container(self):
        # container config
        self._container_config.set_image("nethinks/opennmsenv-management:1.1.0-1")
        if self._app_config.get_value_boolean("setup", "build_images"):
            self._container_config.set_build_path("../../../images/management")
        self._container_config.set_restart_policy("always")
        self._container_config.add_port("2222:22")
        self._container_config.add_environment("CONF_SSH_PASSWORD",
                                               self._container_parameters["ssh_password"])
        self._container_namedvolumes.append("export")
        self._container_namedvolumes.append("management")
        self._container_config.add_volume("export:/data/export")
        self._container_config.add_volume("management:/data/container")
        self._container_config.add_volume("opennms:/data/all-containers/opennms")
        self._container_config.add_volume("rrd:/data/all-containers/rrd")
        self._container_config.add_volume("postgres:/data/all-containers/postgres")
        self._container_config.add_volume("nginx:/data/all-containers/nginx")
        if self._app_config.get_value_boolean("container", "cassandra"):
            self._container_config.add_volume("cassandra:/data/all-containers/cassandra")
        if self._app_config.get_value_boolean("container", "alarmforwarder"):
            self._container_config.add_volume("alarmforwarder:/data/all-containers/alarmforwarder")
        if self._app_config.get_value_boolean("container", "grafana"):
            self._container_config.add_volume("grafana:/data/all-containers/grafana")
        if self._app_config.get_value_boolean("container", "yourdashboard"):
            self._container_config.add_volume("yourdashboard:/data/all-containers/yourdashboard")
        if self._app_config.get_value_boolean("container", "pris"):
            self._container_config.add_volume("pris:/data/all-containers/pris")
        self._container_config.add_volume("./init/management:/data/init")
        self._container_config.add_volume("/var/run/docker.sock:/var/run/docker.sock")

        # create backup config, if required
        if self._container_parameters["backup_enabled"] != "False":
            self._container_config.add_environment("CONF_BACKUP_ENABLED", "TRUE")
            self._container_config.add_environment("CONF_BACKUP_URL",
                                                   self._container_parameters["backup_url"])
 
