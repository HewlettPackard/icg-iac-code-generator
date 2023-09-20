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

# Create virtual machine
resource "openstack_compute_instance_v2" "{{ infra_element_name }}" {
  name        = "{{ name }}"
  image_name  = "{{ os }}"
  flavor_name = "{% if 'sizeDescription' in context().keys() %}{{ sizeDescription }}{% elif 'vm_flavor' in context().keys() %}{{ vm_flavor }}{% else %}{{ instance_type }}{% endif %}"
  key_pair    = openstack_compute_keypair_v2.{{ credentials }}.name
  {%- for key, value in context().items() %}{% if not callable(value)%}{%if key.startswith('NetworkInterface') %}
  network {
    port = openstack_networking_port_v2.{{ value.name ~ "_networking_port"}}.id
  }
  {%- endif %}{% endif %}{% endfor %}
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "{{infra_element_name ~ "_floating_ip"}}" {
  pool = "external"
  # fixed_ip = "{{ address }}"
}

# Attach floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "{{ infra_element_name ~ "_floating_ip_association" }}" {
  floating_ip = openstack_networking_floatingip_v2.{{ infra_element_name ~ "_floating_ip" }}.address
  instance_id = openstack_compute_instance_v2.{{ infra_element_name }}.id
}


{% for key, value in context().items() %}{% if not callable(value)%}{%- if key.startswith('NetworkInterface') %}

{%- if value.associated is not defined %}
# Retrive default security group
data "openstack_compute_secgroup_v2" "default" {
  name = "default"
}
{%- endif %}

{# adding security groups for interfaces #}
# Attach networking port
resource "openstack_networking_port_v2" "{{ value.name ~ "_networking_port" }}" {
  name           = "{{ value.name }}"
{% for net_el in extra_parameters["networks"] %}{% for sub_el in net_el %}{%- if sub_el.endswith(value["belongsTo"]) %}  network_id     = openstack_networking_network_v2.{{ net_el.infra_element_name }}.id
{%- endif %}{% endfor %}{% endfor %}
  admin_state_up = true
{%- if value.associated is defined %}
  security_group_ids = [ openstack_compute_secgroup_v2.{{ value.associated }}.id ] {#  security_group_ids = [ {% for i in value["associated"] %}openstack_compute_secgroup_v2.{{ i.name }}.id {% endfor %}] #}
{%- else %}
  security_group_ids = [ openstack_compute_secgroup_v2.default.id ]
{%- endif %}
  fixed_ip {
   subnet_id = openstack_networking_subnet_v2.{{ value.belongsTo ~ "_subnet" }}.id
  }
}
{%- endif %}{% endif %}{% endfor %}