variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into instances"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}