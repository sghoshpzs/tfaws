resource "aws_instance" "geldsack" {

  count           = length(var.public_sunbet_cidr)

  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = element(aws_subnet.geldsack_public_subnets[*].id, count.index)
  security_groups = [aws_security_group.geldsack_sg.id]
  tags = {
    Name = length(var.public_sunbet_cidr) > 1 ? "${var.ec2_instance_name}-${count.index + 1}" : "${var.ec2_instance_name}"
  }
  key_name        = "geldsack" 

  provisioner "remote-exec" {
    inline = [ "hostname geldsack",
                "yum install -y",
                "yum install docker", 
            ]
  }
  connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${var.geldsack_ssh_key}"
      host = self.public_ip
  }
}
