#! /usr/bin/python3

import argparse
import hashlib
import os
import jinja2


def main():
    # parse arguments
    argparser = argparse.ArgumentParser(description="Create initial OpenNMS users.xml")
    argparser.add_argument("users", nargs="+", help="user format: <username>:<password>")
    arguments = argparser.parse_args()

    # create dict for template engine
    userdata = {}
    userdata["users"] = {}
    for user in arguments.users:
        userparts = user.split(":")
        if len(userparts) < 3:
            continue
        username = userparts[0]
        password = hashlib.md5(userparts[1].encode("utf-8")).hexdigest().upper()
        role = userparts[2]
        userdata["users"][username] = {
            "name": username,
            "description": "user " + username,
            "password": password,
            "role": role
        }

    # create users.xml
    template_dir = os.path.dirname(os.path.realpath(__file__)) + "/templates"
    jinja_env = jinja2.Environment(loader=jinja2.FileSystemLoader(template_dir))
    jinja_tpl = jinja_env.get_template("users.xml.tpl")
    output = jinja_tpl.render(userdata)

    # print output to stdout
    print(output)



if __name__ == "__main__":
    main()
