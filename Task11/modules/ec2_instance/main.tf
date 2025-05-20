resource "aws_instance" "bastion_server" {
  ami = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = var.bastion_vpc_security_group_ids
  subnet_id = var.public_subnet_id
  key_name = var.key_name

  tags = {
    Name = var.bastion_name
  }

  provisioner "file" {
    source      =  var.key_ssh
    destination = var.server_key_destination

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.key_ssh)
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 600 ${var.server_key_destination}",
    ]

    connection {
      type        = "ssh"
      host        = aws_instance.bastion_server.public_ip
      user        = "ec2-user"
      private_key = file(var.key_ssh)
    }
  }
  
}

resource "aws_vpc_security_group_ingress_rule" "private_ssh_rule" {
  security_group_id = var.private_vpc_security_group_ids[0] //aws_security_group.SSH_wireguard_bastion.id
  
  cidr_ipv4 = "${aws_instance.bastion_server.private_ip}/32"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
  description = "Bastion IP"
  tags = {
    Name = "Bastion Allow"
  }
}

resource "aws_instance" "private_server" {
  ami = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = var.private_vpc_security_group_ids
  subnet_id = var.private_subnet_id
  key_name = var.key_name

  tags = {
    Name = var.private_name
  }
}

resource "null_resource" "stat_settings" {
  provisioner "file" {
    source      = var.postgres_install_script
    destination = "/home/ec2-user/postgres_settings.sh"

    connection {
      type        = "ssh"
      host        = aws_instance.bastion_server.public_ip
      user        = "ec2-user"
      private_key = file(var.key_ssh)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/ec2-user/postgres_settings.sh",
      "sudo /home/ec2-user/postgres_settings.sh ${var.server_key_destination} ${aws_instance.private_server.private_ip}"
    ]

    connection {
      type        = "ssh"
      host        = aws_instance.bastion_server.public_ip
      user        = "ec2-user"
      private_key = file(var.key_ssh)
    }
  }
}
