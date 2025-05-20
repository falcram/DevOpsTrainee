resource "aws_vpc" "main" {
  cidr_block           = "10.2.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "terraform-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.2.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-public-subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "terraform-public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.2.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "terraform-private-subnet"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "terraform-private-route-table"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.2.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "b_terraform-private-subnet"
  }
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "b_terraform-private-route-table"
  }
}


resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}


resource "aws_security_group" "SSH_wireguard_bastion" {
  name        = "public-terraform-ssh-wireguard-security-group"
  description = "Allow SSH and WireGuard public traffic"
  vpc_id      = aws_vpc.main.id


  /*ingress {
    description = var.ssh_access.rule_name
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_access.cidr_block]
  }*/

  ingress {
    description = "Wireguard tcp"
    from_port   = 51820
    to_port     = 51820
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Wireguard udp"
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-terraform-ssh-wireguard-security-group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_ssh_rule" {
  security_group_id = aws_security_group.SSH_wireguard_bastion.id

  cidr_ipv4   = var.ssh_access.cidr_block
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
  description = var.ssh_access.rule_name
  tags = {
    Name = var.ssh_access.rule_name
  }
}

resource "aws_security_group" "SSH_wireguard_private" {
  name        = "private-terraform-ssh-wireguard-security-group"
  description = "Allow SSH and WireGuard private traffic"
  vpc_id      = aws_vpc.main.id


  /*ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/16"]
  }*/

  ingress {
    description = "Wireguard tcp"
    from_port   = 51820
    to_port     = 51820
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/16"]
  }

  ingress {
    description = "Wireguard udp"
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["10.2.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-terraform-ssh-wireguard-security-group"
  }
}