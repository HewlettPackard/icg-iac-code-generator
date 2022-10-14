

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
resource "openstack_compute_instance_v2" "OracleDB" {
  name        = ""
  image_name  = "ami-02a6bfdcf8224bd77"
  flavor_name = ""
  key_pair    = openstack_compute_keypair_v2.dbCredentials.name
  network { 
    port = openstack_networking_port_v2.subnet1.id
    
    port = openstack_networking_port_v2.subnet2.id
    
    port = openstack_networking_port_v2.subnet3.id
    
  }
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "OracleDB_floating_ip" {
  pool = "external"
  # fixed_ip = ""
}

# Attach floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "OracleDB_floating_ip_association" {
  floating_ip = openstack_networking_floatingip_v2.OracleDB_floating_ip.address
  instance_id = openstack_compute_instance_v2.OracleDB.id
}



# Create virtual machine
resource "openstack_compute_instance_v2" "gestaut_vm" {
  name        = ""
  image_name  = "ami-02a6bfdcf8224bd77"
  flavor_name = ""
  key_pair    = openstack_compute_keypair_v2.GestautKeyName.name
  network { 
    port = openstack_networking_port_v2.subnet1.id
    
    port = openstack_networking_port_v2.subnet2.id
    
    port = openstack_networking_port_v2.subnet3.id
    
  }
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "gestaut_vm_floating_ip" {
  pool = "external"
  # fixed_ip = ""
}

# Attach floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "gestaut_vm_floating_ip_association" {
  floating_ip = openstack_networking_floatingip_v2.gestaut_vm_floating_ip.address
  instance_id = openstack_compute_instance_v2.gestaut_vm.id
}



# Create virtual machine
resource "openstack_compute_instance_v2" "elasticsearch_vm" {
  name        = ""
  image_name  = "ami-02a6bfdcf8224bd77"
  flavor_name = ""
  key_pair    = openstack_compute_keypair_v2.ESKeyName.name
  network { 
    port = openstack_networking_port_v2.subnet1.id
    
    port = openstack_networking_port_v2.subnet2.id
    
    port = openstack_networking_port_v2.subnet3.id
    
  }
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "elasticsearch_vm_floating_ip" {
  pool = "external"
  # fixed_ip = ""
}

# Attach floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "elasticsearch_vm_floating_ip_association" {
  floating_ip = openstack_networking_floatingip_v2.elasticsearch_vm_floating_ip.address
  instance_id = openstack_compute_instance_v2.elasticsearch_vm.id
}



# Create virtual machine
resource "openstack_compute_instance_v2" "edi_vm" {
  name        = ""
  image_name  = "ami-02a6bfdcf8224bd77"
  flavor_name = ""
  key_pair    = openstack_compute_keypair_v2.EdiKeyName.name
  network { 
    port = openstack_networking_port_v2.subnet1.id
    
    port = openstack_networking_port_v2.subnet2.id
    
    port = openstack_networking_port_v2.subnet3.id
    
  }
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "edi_vm_floating_ip" {
  pool = "external"
  # fixed_ip = ""
}

# Attach floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "edi_vm_floating_ip_association" {
  floating_ip = openstack_networking_floatingip_v2.edi_vm_floating_ip.address
  instance_id = openstack_compute_instance_v2.edi_vm.id
}



## Network

# Create Network
resource "openstack_networking_network_v2" "vpc" {
  name = "concrete_vpc"
}

# Create Subnet
resource "openstack_networking_subnet_v2" "vpc_subnet" {
  name            = "concrete_vpc_subnet"
  network_id      = openstack_networking_network_v2.vpc.id
  cidr            = "10.100.0.0/16"
  dns_nameservers = ["8.8.8.8", "8.8.8.4"]
}

# Attach networking port
resource "openstack_networking_port_v2" "vpc" {
  name           = "concrete_vpc"
  network_id     = openstack_networking_network_v2.vpc.id
  admin_state_up = true
  security_group_ids = [
  openstack_compute_secgroup_v2.salida.id,
  openstack_compute_secgroup_v2.lb.id,
  openstack_compute_secgroup_v2.es.id,
  openstack_compute_secgroup_v2.monitor.id,
  openstack_compute_secgroup_v2.ftp.id,
  
  ]
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.vpc_subnet.id
  }
}

# Create router
resource "openstack_networking_router_v2" "vpc_router" {
  name                = "vpc_router"
  external_network_id = data.openstack_networking_network_v2.external.id    #External network id
}
# Router interface configuration
resource "openstack_networking_router_interface_v2" "vpc_router_interface" {
  router_id = openstack_networking_router_v2.vpc_router.id
  subnet_id = openstack_networking_subnet_v2.vpc_subnet.id
}



# Create ssh keys
resource "openstack_compute_keypair_v2" "dbCredentials" {
  name       = ""
  # public_key = ""
}



# Create ssh keys
resource "openstack_compute_keypair_v2" "GestautKeyName" {
  name       = ""
  # public_key = ""
}



# Create ssh keys
resource "openstack_compute_keypair_v2" "ESKeyName" {
  name       = ""
  # public_key = ""
}



# Create ssh keys
resource "openstack_compute_keypair_v2" "EdiKeyName" {
  name       = ""
  # public_key = ""
}



# CREATING SECURITY_GROUP
  
resource "openstack_compute_secgroup_v2" "salida" {
  name        = "salida"
  description  = "Security group rule for port 0"
  rule {
    from_port   = 0
    to_port     = 0
    ip_protocol = "-1"
    cidr        = "0.0.0.0/0"
  }
}
 
resource "openstack_compute_secgroup_v2" "lb" {
  name        = "lb"
  description  = "Security group rule for port 80"
  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "10.100.1.0/24""10.100.2.0/24""10.100.3.0/24"
  }
}
 
resource "openstack_compute_secgroup_v2" "es" {
  name        = "es"
  description  = "Security group rule for port 9200"
  rule {
    from_port   = 9200
    to_port     = 9200
    ip_protocol = "tcp"
    cidr        = "10.100.1.0/24""10.100.2.0/24""10.100.3.0/24"
  }
}
 
resource "openstack_compute_secgroup_v2" "monitor" {
  name        = "monitor"
  description  = "Security group rule for port 6556"
  rule {
    from_port   = 6556
    to_port     = 6556
    ip_protocol = "tcp"
    cidr        = "54.217.119.81/32"
  }
}
 
resource "openstack_compute_secgroup_v2" "ftp" {
  name        = "ftp"
  description  = "Security group rule for port 22"
  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "213.96.27.139/32""37.187.173.88/32""51.89.40.59/32""195.53.242.200/32"
  }
}


