#!/bin/bash

# add setup scripts
{% for script in scripts %}
{{ script }}
{% endfor %}

# load images if downloaded
{% for image in images %}
docker load -i {{ image }}
{% endfor %}
