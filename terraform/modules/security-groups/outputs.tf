output "wazuh_manager_sg_id" {
  description = "Security Group ID for Wazuh Manager"
  value       = aws_security_group.wazuh_manager_sg.id
}

output "api_sg_id" {
  description = "Security Group ID for API"
  value       = aws_security_group.api_sg.id
}

output "database_sg_id" {
  description = "Security Group ID for Database"
  value       = aws_security_group.database_sg.id
}

output "alb_sg_id" {
  description = "Security Group ID for ALB"
  value       = aws_security_group.alb_sg.id
}