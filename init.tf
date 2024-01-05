terraform {
  cloud {
    organization = "geldsack"

    workspaces {
      name = "aws"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
}


module "geldsack"{
    source              = "./geldsack"
    ami                 = var.ami
    instance_type       = var.instance_type
    ec2_instance_name   = var.ec2_instance_name
}
