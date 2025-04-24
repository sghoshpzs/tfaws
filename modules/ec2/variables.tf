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

variable "private_sunbet_cidr"{
    type = list(string)
    nullable = false
}

variable "public_sunbet_cidr"{
    type = list(string)
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

variable "geldsack_ssh_key" {
    type= string
}
