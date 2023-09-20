{# Copyright 2022 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#-------------------------------------------------------------------------
#}
{##-------- Variables ##}
{%- set var_network_name = infra_element_name -%}
{%- set var_security_groups = infra_sgs -%}
{%- set preexinsting = preexisting -%}

## Network
{%- if preexisting %}
# Retrieve Network
data "openstack_networking_network_v2" "{{ var_network_name }}" {
  name = "{{ name }}"
}

{% for key, value in context().items() %}{% if not callable(value) %}{% if key.startswith('Subnet') %}
# Retrieve Subnet
data "openstack_networking_subnet_v2" "{{ value.name ~ "_subnet" }}" {
  name = "{{ value.name }}"
}
{% endif %}{% endif %}{% endfor %}
{%- else %}
# Create Network
resource "openstack_networking_network_v2" "{{ var_network_name }}" {
  name = "{{ name }}"
}

# Create router
resource "openstack_networking_router_v2" "router_{{ var_network_name }}" { 
  name                = "router_{{ var_network_name }}"
  external_network_id = data.openstack_networking_network_v2.external.id
}

{##-------- Subnets Here ##}
{%- for key, value in context().items() -%}{%- if not callable(value) -%}{%-if key.startswith('Subnet') -%}
# Subnet
resource "openstack_networking_subnet_v2" "{{ value.name ~ "_subnet" }}" {
  name            = "{{ value.name ~ "_subnet" }}"
  network_id      = openstack_networking_network_v2.{{ var_network_name }}.id
  cidr            = "{{ value.addressRange }}"
  dns_nameservers = ["8.8.8.8", "8.8.8.4"]
}

# Create router interface on subnet
resource "openstack_networking_router_interface_v2" "router_interface_{{ var_network_name }}_{{ value.name ~ "_subnet" }}" {
  router_id = "${openstack_networking_router_v2.router_{{ var_network_name }}.id}"
  subnet_id = "${openstack_networking_subnet_v2.{{ value.name ~ "_subnet" }}.id}"
}
{%-endif %}{% endif %}{% endfor %}
{%- endif %}