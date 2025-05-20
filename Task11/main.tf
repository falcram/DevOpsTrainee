terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

data "external" "my_ip" {
  program = ["bash", "${path.root}/getip.sh"]
}

module "vpc" {
  source = "./modules/vpc"
  ssh_access = {
    cidr_block = "${data.external.my_ip.result.ip}/32"
    rule_name  = "My IP"
  }
}

module "ec2_instance" {
  source                         = "./modules/ec2_instance"
  public_subnet_id               = module.vpc.public_subnet_id
  private_subnet_id              = module.vpc.private_subnet_id
  bastion_vpc_security_group_ids = [module.vpc.public_security_group_id]
  private_vpc_security_group_ids = [module.vpc.private_security_group_id]
}

module "rds" {
  source              = "./modules/rds"
  vpc_id              = module.vpc.vpc_id
  private_subnet_id_a = module.vpc.private_subnet_id
  private_subnet_id_b = module.vpc.private_subnet_id_b
}
