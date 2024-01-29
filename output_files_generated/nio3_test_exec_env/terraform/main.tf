

provider "vsphere" {
  user                 = VSPHERE_USER
  password             = VSPHERE_PASSWORD
  vsphere_server       = VSPHERE_SERVER
  allow_unverified_ssl = 
}


# Create virtual machine
resource "vsphere_virtual_machine" "vm1" {
  name        = "concrete_vm"
  resource_pool_id  = ".id"
  datastore_id = ""
  num_cpus = "2"
  memory   = "8192.0"

  network_interface {
    network_id =data.vsphere_network.net1.id //TO BE CHECKED
  }
}


data "vsphere_network" "net1" {
  name          = "concrete_net"
  datacenter_id = data.vsphere_datacenter.datacenter.id //TO BE CHECKED
}


