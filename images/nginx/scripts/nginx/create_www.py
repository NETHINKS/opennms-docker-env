#! /usr/bin/python3

import argparse
import os
import jinja2

def main():
    # parse arguments
    argparser = argparse.ArgumentParser(description="Create start www")
    argparser.add_argument("--support", dest="support", help="support text")
    argparser.add_argument("locations", nargs="+", help="location format: <Name>;<location>;<url>")
    arguments = argparser.parse_args()

    # create dict for template engine
    confdata = {}
    confdata["support"] = arguments.support
    confdata["locations"] = []
    for locationarg in arguments.locations:
        locationparts = locationarg.split(";")
        if len(locationparts) < 3:
            continue
        location = {
            "name": locationparts[0],
            "location": locationparts[1],
            "url": locationparts[2]
        }
        confdata["locations"].append(location)

    # create index.html
    template_dir = os.path.dirname(os.path.realpath(__file__)) + "/templates"
    jinja_env = jinja2.Environment(loader=jinja2.FileSystemLoader(template_dir))
    jinja_tpl = jinja_env.get_template("index.html.tpl")
    output = jinja_tpl.render(confdata)

    # print output to stdout
    print(output)


if __name__  == "__main__":
    main()
