resource "aws_security_group" "wazuh_manager_sg" {
    name = "wazuh-manager-sg"
    description = "Security group for Wazuh Manager"
    vpc_id = var.vpc_id    
    
    tags = {
        Name = "Wazuh-Manager-SG"
    }
}

resource "aws_security_group" "api_sg" {
    name = "api-sg"
    description = "Security group for API"
    vpc_id = var.vpc_id    
    
    tags = {
        Name = "API-SG"
    }
}

resource "aws_security_group" "database_sg" {
    name = "database-sg"
    description = "Security group for Database"
    vpc_id = var.vpc_id    
    
    tags = {
        Name = "Database-SG"
    }
}

resource "aws_security_group" "alb_sg" {
    name = "alb-sg"
    description = "Security group for Application Load Balancer"
    vpc_id = var.vpc_id    
    
    tags = {
        Name = "ALB-SG"
    }
}

resource "aws_vpc_security_group_ingress_rule" "allow_1514_wazuh_to_manager" {
    security_group_id = aws_security_group.wazuh_manager_sg.id
    
    referenced_security_group_id = aws_security_group.wazuh_manager_sg
    to_port = 1514
    from_port = 1514
    ip_protocol = "udp"
} 
resource "aws_vpc_security_group_ingress_rule" "allow_1515_wazuh_to_manager" {
    security_group_id = aws_security_group.wazuh_manager_sg.id
    
    referenced_security_group_id = aws_security_group.wazuh_manager_sg
    to_port = 1515
    from_port = 1515
    ip_protocol = "tcp"
} 

#  Manager
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_internet_manager" {
    security_group_id = aws_security_group.wazuh_manager_sg

    cidr_ipv4  = var.allowed_ssh_cidr
    to_port = 22
    from_port = 22
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_from_internet_manager" {
    security_group_id = aws_security_group.wazuh_manager_sg

    cidr_ipv4  = var.allowed_ssh_cidr
    to_port = 443
    from_port = 443
    ip_protocol = "tcp"
}

# API
resource "aws_vpc_security_group_ingress_rule" "allow_https_from_internet_api" {
    security_group_id = aws_security_group.api_sg

    cidr_ipv4 = "0.0.0.0/0"
    to_port = 443
    from_port = 443
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_internet_api" {
    security_group_id = aws_security_group.api_sg

    cidr_ipv4 = var.allowed_ssh_cidr
    to_port = 22
    from_port = 22
    ip_protocol = "tcp"
} 

resource "aws_vpc_security_group_egress_rule" "allow_https_to_alb" {
    security_group_id = aws_security_group.api_sg

    referenced_security_group_id = aws_security_group.alb_sg
    to_port = 443
    from_port = 443
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_postgres_from_api_database" {
    security_group_id = aws_security_group.api_sg.id

    referenced_security_group_id = aws_security_group.database_sg
    to_port = 5432
    from_port = 5432
    ip_protocol = "tcp"
} 

// Database
resource "aws_vpc_security_group_ingress_rule" "allow_api_postgres" {
    security_group_id = aws_security_group.database_sg.id
    
    referenced_security_group_id = aws_security_group.api_sg
    to_port = 0
    from_port = 0
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_postgres" {
    security_group_id = aws_security_group.api_sg
    
    cidr_ipv4 = var.allowed_ssh_cidr
    to_port = 22
    from_port = 22
    ip_protocol = "tcp"
}


// ALB
resource "aws_vpc_security_group_ingress_rule" "allow_https_alb" {
    security_group_id = aws_security_group.alb_sg

    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_alb" {
    security_group_id = aws_security_group.alb_sg

    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
}
