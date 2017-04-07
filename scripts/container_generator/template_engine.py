"""template engine for container_generator

This module abstracts the template engine for the application.
At the moment, Jinja2 is used as engine
"""
import shutil
import re
from jinja2 import Environment
from jinja2 import FileSystemLoader

class TemplateEngine(object):
    """TemplateEngine class

    This class can be used for generating templates. It is a wrapper around
    Jinja2. Templates must be placed in the templates subdirectory.
    """

    def __init__(self):
        """Initialization method"""
        self.__jinja_loader = FileSystemLoader(".")
        self.__jinja_environment = Environment(loader=self.__jinja_loader)

    def render_template(self, name, context):
        """Render the given template and return the content as string

        Args:
            name: name of the template file
            context: dict with data for the template
        """
        template = self.__jinja_environment.get_template(name)
        return template.render(context)

    def render_template_to_file(self, name, output_file_name, context):
        with open(output_file_name, "w") as output_file:
            output_file.write(self.render_template(name, context))

    def render_directory(self, template_dir, output_dir, context):
        def copy_or_render(src, dst, *, follow_symlinks=True):
            if src.endswith(".tpl"):
                dst = re.sub("\.tpl$", "", dst)
                self.render_template_to_file(src, dst, context)
            else:
                shutil.copy2(src, dst)
        shutil.copytree(template_dir, output_dir, copy_function=copy_or_render)
