

output "instance_server_public_key_dbCredentials_OracleDB" {
  value = aws_key_pair.dbCredentials.public_key
}

output "instance_server_public_ip_OracleDB" {
  value = aws_instance.OracleDB.public_ip
}

output "instance_public_dns_OracleDB" {
  value = aws_instance.OracleDB.public_dns
}

output "instance_server_private_key_dbCredentials_OracleDB" {
  value = nonsensitive(tls_private_key.example.private_key_openssh)
}

