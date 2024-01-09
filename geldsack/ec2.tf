resource "aws_instance" "geldsack"{
  count = length(var.private_sunbet_cidr)

  ami           = var.ami
  instance_type = var.instance_type
  subnet_id = element(aws_subnet.geldsack_private_subnets[*].id, count.index)
  security_groups = [aws_security_group.geldsack_sg.id]
  tags = {
    Name = length(var.private_sunbet_cidr) > 1 ? "${var.ec2_instance_name}-${count.index + 1}" : "${var.ec2_instance_name}"
  }
}
