resource "aws_db_subnet_group" "db_group" {
  name       = "main"
  subnet_ids = [var.private_subnet_id_a, var.private_subnet_id_b]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier = "terraform-postgres"
  engine = "postgres"
  engine_version = "17.5"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  storage_type = "gp2"

  username = var.db_username
  password = var.db_password
  db_name = var.db_name

  db_subnet_group_name = aws_db_subnet_group.db_group.name
  vpc_security_group_ids = [aws_security_group.allow_postgres.id]

  publicly_accessible  = false
  multi_az             = false
  skip_final_snapshot  = true

  tags = {
    Name = "terraform PostgreSQL Free"
  }
}

resource "aws_security_group" "allow_postgres" {
  name   = "allow-postgres"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_sg_group]
    description = "Allow PostgreSQL from VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}