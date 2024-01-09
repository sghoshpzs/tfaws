resource "aws_instance" "geldsack"{
  count = length(var.private_sunbet_cidr)

  ami           = var.ami
  instance_type = var.instance_type
  subnet_id = element(aws_subnet.geldsack_private_subnets[*].id, count.index)
  tags = {
    Name = "${var.ec2_instance_name}-${count.index + 1}"
  }
}
