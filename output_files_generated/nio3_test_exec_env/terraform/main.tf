

terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
  insecure    = true
}

# Retrieve data
data "openstack_networking_network_v2" "external" {
  name = "external"
}



# Create virtual machine
resource "openstack_compute_instance_v2" "vm1" {
  name        = "con_vm1"
  image_name  = "centos7_64Guest"
  flavor_name = ""
  key_pair    = openstack_compute_keypair_v2.ssh_key.name
  network {
    port = openstack_networking_port_v2.i1_networking_port.id
  }
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "vm1_floating_ip" {
  pool = "external"
  # fixed_ip = ""
}

# Attach floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "vm1_floating_ip_association" {
  floating_ip = openstack_networking_floatingip_v2.vm1_floating_ip.address
  instance_id = openstack_compute_instance_v2.vm1.id
}



# Retrive default security group
data "openstack_compute_secgroup_v2" "default" {
  name = "default"
}


# Attach networking port
resource "openstack_networking_port_v2" "i1_networking_port" {
  name           = "i1"

  admin_state_up = true
  security_group_ids = [ openstack_compute_secgroup_v2.default.id ]
  fixed_ip {
   subnet_id = openstack_networking_subnet_v2.net1_subnet.id
  }
}


## Network
# Retrieve Network
data "openstack_networking_network_v2" "net1" {
  name = "network"
}





# Create ssh keys
resource "openstack_compute_keypair_v2" "ssh_key" {
  name       = ""
  # public_key = ""
}

