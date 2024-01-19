variable "ami"{
    type = string
    nullable = false
}

variable "instance_type"{
    type = string
    nullable = false
}

variable "ec2_instance_name"{
    type = string
    nullable = false
}

variable "vpc_name"{
    type = string
    nullable = false
}

variable "vpc_cidr"{
    type = string
    nullable = false
}

variable "private_sunbet_cidr"{
    type = list(string)
    nullable = false
}

variable "private_sunbet_name"{
    type = string
    nullable = false
}

variable "public_sunbet_cidr"{
    type = list(string)
    nullable = false
}

variable "public_sunbet_name"{
    type = string
    nullable = false
}

variable "public_subnet_az"{
    type = list(string)
    default = [ "ap-south-1a", "ap-south-1b", "ap-south-1c" ]
}


variable "private_subnet_az"{
    type = list(string)
    default = [ "ap-south-1a", "ap-south-1b", "ap-south-1c" ]
}

variable "sg_ingress_ports" {
    type = list(list(string))
    nullable = false
}

variable "sg_egress_ports" {
    type = list(list(string))
    nullable = false
}

variable "geldsack_ssh_key" {
    type= string
}