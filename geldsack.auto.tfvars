# variables.tfvars


ami                 = "ami-03f4878755434977f"
instance_type       = "t2.micro"
ec2_instance_name   = "geldsack"
vpc_name            = "geldsack"
vpc_cidr            = "192.168.0.0/24"
private_sunbet_cidr = ["192.168.0.16/28"]
private_sunbet_name = "geldsack-private-subnet"
private_subnet_az    = [ "ap-south-1b" ]
public_sunbet_cidr  = ["192.168.0.32/28"]
public_sunbet_name  = "geldsack-public-subnet"
public_subnet_az    = [ "ap-south-1a" ]
sg_ingress_ports    = [[22, 22, "tcp", "ssh"]]
sg_egress_ports     = [[80, 80, "tcp", "http"], [443, 443, "tcp", "https"]]

