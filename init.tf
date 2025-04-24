terraform {
  cloud {
    organization = "geldsack"

    workspaces {
      name = "aws"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}


module "vpc" {
  source              = "./modules/vpc"
  vpc_name            = var.vpc_name
  vpc_cidr            = var.vpc_cidr
  private_sunbet_cidr = var.private_sunbet_cidr
  private_sunbet_name = var.private_sunbet_name
  public_sunbet_cidr  = var.public_sunbet_cidr
  public_sunbet_name  = var.public_sunbet_name
  sg_egress_ports     = var.sg_egress_ports
  sg_ingress_ports    = var.sg_ingress_ports
}


module "ec2" {
  source              = "./modules/ec2"
  ami                 = var.ami
  instance_type       = var.instance_type
  ec2_instance_name   = var.ec2_instance_name
  private_sunbet_cidr = var.private_sunbet_cidr
  public_sunbet_cidr  = var.public_sunbet_cidr
  geldsack_ssh_key    = var.geldsack_ssh_key
}

# output "vpc_id" {
#   value = module.geldsack.vpc_id
# }

output "ec2_public_ip_address" {  
  value = module.geldsack.ec2_public_ip_addresses
}
