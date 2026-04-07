module "network" {
    source = "../../modules/network"
}

module "security_groups" {
  source = "../../modules/security-groups"
  vpc_id = module.network.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

module "compute" {
  source = "../../modules/compute"
  key_name = aws_key_pair.wazuh_lab.key_name
}


resource "aws_key_pair" "wazuh_lab" {
  key_name   = "wazuh-lab-key"
  public_key = file("~/.ssh/wazuh-lab-key.pub")
}
