output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "private_subnet_id_b" {
  value = aws_subnet.private_b.id
}

output "public_security_group_id" {
  value = aws_security_group.SSH_wireguard_bastion.id
}

output "private_security_group_id" {
  value = aws_security_group.SSH_wireguard_private.id
}