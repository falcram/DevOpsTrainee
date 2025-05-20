output "db_host" {
  value = aws_db_instance.postgres.address
}

output "db_username" {
  value = var.db_username
}

output "db_name" {
  value = var.db_name
}

output "db_password" {
  value = var.db_password
}