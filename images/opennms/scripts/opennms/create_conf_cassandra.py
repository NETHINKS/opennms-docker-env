#! /usr/bin/python3

import argparse
import hashlib
import os
import jinja2


def main():
    # parse arguments
    argparser = argparse.ArgumentParser(description="Create OpenNMS cassandra config")
    argparser.add_argument("server", help="cassandra server")
    argparser.add_argument("user", help="cassandra user")
    argparser.add_argument("password", help="cassandra password")
    arguments = argparser.parse_args()

    # create dict for template engine
    data = {}
    data["server"] = arguments.server
    data["user"] = arguments.user
    data["password"] = arguments.password

    # create cassandra.properties
    template_dir = os.path.dirname(os.path.realpath(__file__)) + "/templates"
    jinja_env = jinja2.Environment(loader=jinja2.FileSystemLoader(template_dir))
    jinja_tpl = jinja_env.get_template("cassandra.properties.tpl")
    output = jinja_tpl.render(data)

    # print output to stdout
    print(output)



if __name__ == "__main__":
    main()
