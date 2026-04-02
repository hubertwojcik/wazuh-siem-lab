resource "aws_vpc" "main_vpc" {
    cidr_block = var.vpc_cidr
    
    tags = {
        Name = "main-vpc"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = var.public_subnet_cidr
    availability_zone = var.availability_zone

    tags = {
        Name = "public_subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = var.private_subnet_cidr
    availability_zone = var.availability_zone
    
    tags = {
        Name = "private_subnet"
    }
}

resource "aws_internet_gateway" "main_igw" {
    vpc_id = aws_vpc.main_vpc.id
    
    tags = {
        Name = "VPC Internet Gateway"
    }
}

resource "aws_eip" "main_elastic_ip" {
    domain = "vpc"        
    
    tags = {
        Name = "Main Elastic IP"
    }
}

resource "aws_nat_gateway" "private_subnet_nat" {
  allocation_id = aws_eip.main_elastic_ip.id
  subnet_id = aws_subnet.public_subnet.id
  
  tags = {
    Name = "Private Subnet NAT Gateway"
  }
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.main_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main_igw.id
    }
}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.main_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.private_subnet_nat.id
    }
}

resource "aws_route_table_association" "public_route_table_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_table_association" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_route_table.id
}
