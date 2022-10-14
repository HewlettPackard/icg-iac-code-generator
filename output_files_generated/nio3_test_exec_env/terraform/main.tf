

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
  name        = "concrete_vm"
  image_name  = "ubuntu-20.04.3"
  flavor_name = ""
  key_pair    = openstack_compute_keypair_v2..name
  network { 
    port = openstack_networking_port_v2.net1.id
    
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


## Network

# Create Network
resource "openstack_networking_network_v2" "net1" {
  name = "concrete_net"
}



# Attach networking port
resource "openstack_networking_port_v2" "net1" {
  name           = "concrete_net"
  network_id     = openstack_networking_network_v2.net1.id
  admin_state_up = true
  security_group_ids = [
  
  ]
  # fixed_ip { ## TODO to be fixed (not working for posidonia example, needed for openstack example)
  #  subnet_id = openstack_networking_subnet_v2.net1_subnet.id
  #}
}

# Create router
resource "openstack_networking_router_v2" "net1_router" {
  name                = "net1_router"
  external_network_id = data.openstack_networking_network_v2.external.id    #External network id
}
# Router interface configuration
resource "openstack_networking_router_interface_v2" "net1_router_interface" {
  router_id = openstack_networking_router_v2.net1_router.id
  # subnet_id = openstack_networking_subnet_v2.net1_subnet.id ## TODO to be fixed (not working for posidonia example, needed for openstack example)
}

