output "wazuh_manager_public_ip" {
  value = aws_instance.wazuh_manager.public_ip
}

output "api_public_ip" {
  value = aws_instance.api.public_ip
}

output "database_private_ip" {
  value = aws_instance.database.private_ip
}