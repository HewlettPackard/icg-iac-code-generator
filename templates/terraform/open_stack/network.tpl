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

## Network

# Create Network
resource "openstack_networking_network_v2" "{{ var_network_name }}" {
  name = "{{ name }}"
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
{%-endif %}{% endif %}{% endfor %}

# Attach networking port
resource "openstack_networking_port_v2" "{{ infra_element_name }}" {
  name           = "{{ name }}"
  network_id     = openstack_networking_network_v2.{{ var_network_name }}.id
  admin_state_up = true
  security_group_ids = [
  {% for sg in infra_sgs %}openstack_compute_secgroup_v2.{{sg}}.id,
  {% endfor %}
  ]
  # fixed_ip { ## TODO to be fixed (not working for posidonia example, needed for openstack example)
  #  subnet_id = openstack_networking_subnet_v2.{{ infra_element_name ~ "_subnet" }}.id
  #}
}

# Create router
resource "openstack_networking_router_v2" "{{ var_network_name ~ "_router" }}" {
  name                = "{{ var_network_name ~ "_router" }}"
  external_network_id = data.openstack_networking_network_v2.external.id    #External network id
}
# Router interface configuration
resource "openstack_networking_router_interface_v2" "{{ var_network_name ~ "_router_interface" }}" {
  router_id = openstack_networking_router_v2.{{ var_network_name ~ "_router" }}.id
  # subnet_id = openstack_networking_subnet_v2.{{ infra_element_name ~ "_subnet" }}.id ## TODO to be fixed (not working for posidonia example, needed for openstack example)
}