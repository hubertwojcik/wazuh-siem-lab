data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-22.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_instance" "wazuh_manager" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  subnet_id = module.network.public_subnet_id
  vpc_security_group_ids = [module.security_groups.wazuh_manager_sg_id]
  associate_public_ip_address = true
  key_name = var.key_name

  tags = {
    Name = "wazuh-manager"
  }
}

resource "aws_instance" "database" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  subnet_id = module.network.private_subnet_id
  vpc_security_group_ids = [module.security_groups.database_sg_id]
  associate_public_ip_address = false
  key_name = var.key_name

  tags = {
    Name = "wazuh-database"
  }
}

resource "aws_instance" "api" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = module.network.public_subnet_id
  vpc_security_group_ids = [module.security_groups.api_sg_id]
  associate_public_ip_address = true
  key_name = var.key_name

  tags = {
    Name = "wazuh-api"
  }
}