resource "aws_instance" "geldsack"{
  ami           = var.ami
  instance_type = var.instance_type
  tags = {
    Name = var.ec2_instance_name
  }
}
