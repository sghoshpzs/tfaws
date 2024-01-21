#-------------------------------VPC Creation-------------------------------#

resource "aws_vpc" "geldsack" {
    cidr_block       = var.vpc_cidr
    instance_tenancy = "default"

    tags = {
        Name = var.vpc_name
    }
}

output "vpc_id" {
    value = aws_vpc.geldsack.id
}

#--------------------------------AWS Subnets-------------------------------#

resource "aws_subnet" "geldsack_private_subnets" {
    count                   = length(var.private_sunbet_cidr)
    vpc_id                  = aws_vpc.geldsack.id
    availability_zone       = element(var.private_subnet_az, count.index)
    map_public_ip_on_launch = false
    cidr_block              = element(var.private_sunbet_cidr, count.index)
    tags = {
        Name = length(var.private_sunbet_cidr) > 1 ? "${var.vpc_name}-private-subnet-${count.index + 1}" : "${var.vpc_name}-private-subnet"
    }
}

resource "aws_subnet" "geldsack_public_subnets" {
    count                   = length(var.public_sunbet_cidr)
    vpc_id                  = aws_vpc.geldsack.id
    availability_zone       = element(var.public_subnet_az, count.index)
    map_public_ip_on_launch = true
    cidr_block              = element(var.public_sunbet_cidr, count.index)
    tags = {
        Name = length(var.public_sunbet_cidr) > 1 ? "${var.vpc_name}-public-subnet-${count.index + 1}" : "${var.vpc_name}-public-subnet"
    }
}

#------------------------------Internet Gateway----------------------------#

resource "aws_internet_gateway" "geldsack_igw"{
    vpc_id = aws_vpc.geldsack.id
    tags = {
        Name = "${var.vpc_name}-igw"
    }
}

#---------------------------------Route Table------------------------------#

resource "aws_default_route_table" "geldsack_private_route_table" {
    default_route_table_id  = aws_vpc.geldsack.default_route_table_id
    tags = {
        Name = "${var.vpc_name}-private-rt"
    }
}

resource "aws_route_table" "geldsack_public_route_table" {
    vpc_id = aws_vpc.geldsack.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.geldsack_igw.id
    }

    tags = {
        Name = "${var.vpc_name}-public-rt"
    }
}

resource "aws_route_table_association" "geldsack_public_subnet_association_with_rt"{
    count           = length(var.public_sunbet_cidr)
    
    route_table_id  = aws_route_table.geldsack_public_route_table.id
    subnet_id       = element(aws_subnet.geldsack_public_subnets[*].id, count.index)
}

#--------------------------------Security Group----------------------------#

resource "aws_security_group" "geldsack_sg" {
    vpc_id = aws_vpc.geldsack.id

    tags = {
        Name = "${var.vpc_name}-sg"
    }
  
}

resource "aws_security_group_rule" "geldsack_sg_ingress_rules" {
    count               = length(var.sg_ingress_ports)
    type                = "ingress"
    from_port           = var.sg_ingress_ports[count.index][0] 
    to_port             = var.sg_ingress_ports[count.index][1] 
    protocol            = var.sg_ingress_ports[count.index][2]
    description         = var.sg_ingress_ports[count.index][3]
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = aws_security_group.geldsack_sg.id
}

resource "aws_security_group_rule" "geldsack_sg_egress_rules" {
    count               = length(var.sg_egress_ports)
    type                = "egress"
    from_port           = var.sg_egress_ports[count.index][0] 
    to_port             = var.sg_egress_ports[count.index][1] 
    protocol            = var.sg_egress_ports[count.index][2]
    description         = var.sg_egress_ports[count.index][3]
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = aws_security_group.geldsack_sg.id
}

#--------------------------------------------------------------------------#