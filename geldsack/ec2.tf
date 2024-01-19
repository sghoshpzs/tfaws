resource "aws_instance" "geldsack"{

  count           = length(var.private_sunbet_cidr)

  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = element(aws_subnet.geldsack_public_subnets[*].id, count.index)
  security_groups = [aws_security_group.geldsack_sg.id]
  key_name        = "geldsack"
  tags = {
    Name = length(var.public_sunbet_cidr) > 1 ? "${var.ec2_instance_name}-${count.index + 1}" : "${var.ec2_instance_name}"
  }
  
  provisioner "remote-exec" {
    inline = [ "hostname geldsack",
                "yum install -y",
                "yum install docker"]
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${var.geldsack_ssh_key}"
    host = self.public_ip
  }
}
