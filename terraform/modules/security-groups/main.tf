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

#  Manager
resource "aws_vpc_security_group_ingress_rule" "allow_1514_from_api_to_manager" {
    security_group_id = aws_security_group.wazuh_manager_sg.id
    
    referenced_security_group_id = aws_security_group.api_sg.id
    to_port = 1514
    from_port = 1514
    ip_protocol = "tcp"
} 
resource "aws_vpc_security_group_ingress_rule" "allow_1515_from_api_to_manager" {
    security_group_id = aws_security_group.wazuh_manager_sg.id
    
    referenced_security_group_id = aws_security_group.api_sg.id
    to_port = 1515
    from_port = 1515
    ip_protocol = "tcp"
} 

resource "aws_vpc_security_group_ingress_rule" "allow_1514_from_database_to_manager" {
    security_group_id = aws_security_group.wazuh_manager_sg.id
    
    referenced_security_group_id = aws_security_group.database_sg.id
    to_port = 1514
    from_port = 1514
    ip_protocol = "tcp"
} 
resource "aws_vpc_security_group_ingress_rule" "allow_1515_from_database_to_manager" {
    security_group_id = aws_security_group.wazuh_manager_sg.id
    
    referenced_security_group_id = aws_security_group.database_sg.id
    to_port = 1515
    from_port = 1515
    ip_protocol = "tcp"
} 

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_internet_manager" {
    security_group_id = aws_security_group.wazuh_manager_sg.id

    cidr_ipv4  = var.allowed_ssh_cidr
    to_port = 22
    from_port = 22
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_from_internet_manager" {
    security_group_id = aws_security_group.wazuh_manager_sg.id

    cidr_ipv4  = var.allowed_ssh_cidr
    to_port = 443
    from_port = 443
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_https_to_manager_internet" {
    security_group_id = aws_security_group.wazuh_manager_sg.id

    cidr_ipv4  = "0.0.0.0/0"
    to_port = 443
    from_port = 443
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_http_to_manager_internet" {
    security_group_id = aws_security_group.wazuh_manager_sg.id

    cidr_ipv4  = "0.0.0.0/0"
    to_port = 80
    from_port = 80
    ip_protocol = "tcp"
}


# API
resource "aws_vpc_security_group_ingress_rule" "allow_3000_from_alb_api" {
    security_group_id = aws_security_group.api_sg.id

    referenced_security_group_id = aws_security_group.alb_sg.id
    to_port = 3000
    from_port = 3000
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_internet_api" {
    security_group_id = aws_security_group.api_sg.id

    cidr_ipv4 = var.allowed_ssh_cidr
    to_port = 22
    from_port = 22
    ip_protocol = "tcp"
} 

resource "aws_vpc_security_group_egress_rule" "allow_postgres_from_api_database" {
    security_group_id = aws_security_group.api_sg.id    

    referenced_security_group_id = aws_security_group.database_sg.id
    to_port = 5432
    from_port = 5432
    ip_protocol = "tcp"
} 

resource "aws_vpc_security_group_egress_rule" "allow_1514_from_api_to_manager" {
    security_group_id = aws_security_group.api_sg.id
    
    referenced_security_group_id = aws_security_group.wazuh_manager_sg.id
    to_port = 1514
    from_port = 1514
    ip_protocol = "tcp"
} 
resource "aws_vpc_security_group_egress_rule" "allow_1515_from_api_to_manager" {
    security_group_id = aws_security_group.api_sg.id
    
    referenced_security_group_id = aws_security_group.wazuh_manager_sg.id
    to_port = 1515
    from_port = 1515
    ip_protocol = "tcp"
} 


// Database
resource "aws_vpc_security_group_ingress_rule" "allow_postgres_from_api" {
    security_group_id = aws_security_group.database_sg.id
    
    referenced_security_group_id = aws_security_group.api_sg.id
    to_port = 5432
    from_port = 5432
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_api" {
    security_group_id = aws_security_group.database_sg.id
    
    referenced_security_group_id = aws_security_group.api_sg.id
    to_port = 22
    from_port = 22
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_1514_database_manager" {
    security_group_id = aws_security_group.database_sg.id
    
    referenced_security_group_id = aws_security_group.wazuh_manager_sg.id
    to_port = 1514
    from_port = 1514
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_1515_database_manager" {
    security_group_id = aws_security_group.database_sg.id
    
    referenced_security_group_id = aws_security_group.wazuh_manager_sg.id
    to_port = 1515
    from_port = 1515
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_https_database_internet" {
    security_group_id = aws_security_group.database_sg.id
    
    cidr_ipv4 = "0.0.0.0/0"
    to_port = 443
    from_port = 443
    ip_protocol = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "allow_http_database_internet" {
    security_group_id = aws_security_group.database_sg.id
    
    cidr_ipv4 = "0.0.0.0/0"
    to_port = 80
    from_port = 80
    ip_protocol = "tcp"
}

// ALB
resource "aws_vpc_security_group_ingress_rule" "allow_https_internet_alb" {
    security_group_id = aws_security_group.alb_sg.id

    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_internet_alb" {
    security_group_id = aws_security_group.alb_sg.id

    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_3000_alb_api" {
    security_group_id = aws_security_group.alb_sg.id

    referenced_security_group_id = aws_security_group.api_sg.id
    from_port = 3000
    to_port = 3000
    ip_protocol = "tcp"
}
