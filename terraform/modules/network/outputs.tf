output "vpc_id" {
    value = aws_vpc.main_vpc.id
}

output "public_subnet_id" {
    value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
    value = aws_subnet.private_subnet.id
}

output "elastic_ip_id" {
    value = aws_eip.main_elastic_ip.id
}

output "nat_gateway_id" {
    value = aws_nat_gateway.private_subnet_nat.id
}