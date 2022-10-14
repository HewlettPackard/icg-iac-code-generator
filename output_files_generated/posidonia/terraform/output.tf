

output "instance_server_public_key_dbCredentials" {
  value = openstack_compute_keypair_v2.dbCredentials.public_key
}

output "instance_server_private_key_dbCredentials" {
  value = openstack_compute_keypair_v2.dbCredentials.private_key
}

output "instance_ip_OracleDB" {
  value = openstack_compute_floatingip_associate_v2.OracleDB_floating_ip_association.floating_ip
}



output "instance_server_public_key_GestautKeyName" {
  value = openstack_compute_keypair_v2.GestautKeyName.public_key
}

output "instance_server_private_key_GestautKeyName" {
  value = openstack_compute_keypair_v2.GestautKeyName.private_key
}

output "instance_ip_gestaut_vm" {
  value = openstack_compute_floatingip_associate_v2.gestaut_vm_floating_ip_association.floating_ip
}



output "instance_server_public_key_ESKeyName" {
  value = openstack_compute_keypair_v2.ESKeyName.public_key
}

output "instance_server_private_key_ESKeyName" {
  value = openstack_compute_keypair_v2.ESKeyName.private_key
}

output "instance_ip_elasticsearch_vm" {
  value = openstack_compute_floatingip_associate_v2.elasticsearch_vm_floating_ip_association.floating_ip
}



output "instance_server_public_key_EdiKeyName" {
  value = openstack_compute_keypair_v2.EdiKeyName.public_key
}

output "instance_server_private_key_EdiKeyName" {
  value = openstack_compute_keypair_v2.EdiKeyName.private_key
}

output "instance_ip_edi_vm" {
  value = openstack_compute_floatingip_associate_v2.edi_vm_floating_ip_association.floating_ip
}

