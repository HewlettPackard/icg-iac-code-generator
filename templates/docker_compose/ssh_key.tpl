{%- for image in extra_parameters %}{% if image["maps"] is sameas generatedFrom["name"] %}{% for cont in image["generatedContainers"] %}{% if cont["name"] is sameas name %}{% if "hostConfigs" in cont %}{% raw %}{{ instance_server_private_key_ssh_key_{% endraw %}{{ cont.hostConfigs.0.host }} {% raw %}}}{% endraw %}
{%- endif %}{% endif %}{% endfor %}{% endif %}{%- endfor %}