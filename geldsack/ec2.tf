data "aws_ami" "amazon_linux_ami" {
  filter {
    name   = "name"
    values = ["amzn*-ami-hvm-*-x86*64-gp*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  most_recent = true
  owners      = ["amazon"]

}


resource "aws_instance" "geldsack" {

  count                   = length(var.public_sunbet_cidr)

  ami                     = data.aws_ami.amazon_linux_ami.id
  instance_type           = var.instance_type
  subnet_id               = element(aws_subnet.geldsack_public_subnets[*].id, count.index)
  vpc_security_group_ids  = [aws_security_group.geldsack_sg.id]
  key_name                = "geldsack" 
  tags = {
    Name = length(var.public_sunbet_cidr) > 1 ? "${var.ec2_instance_name}-${count.index + 1}" : "${var.ec2_instance_name}"
  }

  # ami = data.aws_ami.amazon_linux_ami.id
  # instance_type = var.instance_type
  # subnet_id = aws_subnet.geldsack_public_subnets[0].id
  # vpc_security_group_ids = [aws_security_group.geldsack_sg.id]
  # key_name        = "geldsack" 

  # tags = {
  #   Name = "${var.ec2_instance_name}"
  # }

  # provisioner "remote-exec" {
  #   inline = [ "hostname geldsack",
  #               "yum install -y",
  #               "yum install docker", 
  #           ]
  # }
  # connection {
  #     type = "ssh"
  #     user = "ubuntu"
  #     private_key = "${var.geldsack_ssh_key}"
  #     host = self.public_ip
  # }
}

output "ec2_public_ip_addresses" {
  value = tomap({

    for k, inst in aws_instance.geldsack : k => {
      id = inst.id
      public_ip = inst.public_ip
    }
  })
}