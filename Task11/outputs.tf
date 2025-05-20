output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

/*output "public_security_group" {
  value = module.vpc.public_security_group_id
}

output "private_security_group" {
  value = module.vpc.private_security_group_id
}*/

output "bastion_public_ip" {
  value = module.ec2_instance.bastion_public_ip
}

output "bastion_local_ip" {
  value = module.ec2_instance.bastion_local_ip
}

output "private_local_ip" {
  value = module.ec2_instance.private_local_ip
}

output "db_host" {
  value = module.rds.db_host
}

output "db_userame" {
  value = module.rds.db_username
}

output "db_name" {
  value = module.rds.db_name
}

output "db_password" {
  value = module.rds.db_password
}