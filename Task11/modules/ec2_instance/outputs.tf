output "bastion_public_ip" {
  value = aws_instance.bastion_server.public_ip
}

output "bastion_local_ip" {
  value = aws_instance.bastion_server.private_ip
}

output "private_local_ip" {
  value = aws_instance.private_server.private_ip
}
