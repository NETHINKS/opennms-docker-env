#! /usr/bin/python3

import argparse
import hashlib
import os
import jinja2


def main():
    # parse arguments
    argparser = argparse.ArgumentParser(description="Create yourDashboard  config")
    argparser.add_argument("url", help="OpenNMS URL")
    argparser.add_argument("user", help="OpenNMS api user")
    argparser.add_argument("password", help="OpenNMS api password")
    arguments = argparser.parse_args()

    # create dict for template engine
    data = {}
    data["url"] = arguments.url
    data["user"] = arguments.user
    data["password"] = arguments.password

    # create dashboard-configuration.xml
    template_dir = os.path.dirname(os.path.realpath(__file__)) + "/templates"
    jinja_env = jinja2.Environment(loader=jinja2.FileSystemLoader(template_dir))
    jinja_tpl = jinja_env.get_template("dashboard-configuration.xml.tpl")
    output = jinja_tpl.render(data)

    # print output to stdout
    print(output)



if __name__ == "__main__":
    main()
