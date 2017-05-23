#! /usr/bin/python3

import argparse
import hashlib
import os
import jinja2


def main():
    # create web-base.properties
    template_dir = os.path.dirname(os.path.realpath(__file__)) + "/templates"
    jinja_env = jinja2.Environment(loader=jinja2.FileSystemLoader(template_dir))
    jinja_tpl = jinja_env.get_template("web-base.properties.tpl")
    output = jinja_tpl.render()

    # print output to stdout
    print(output)



if __name__ == "__main__":
    main()
