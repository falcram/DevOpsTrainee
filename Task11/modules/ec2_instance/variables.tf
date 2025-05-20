variable "ami" {
  type = string
  default = "ami-0953476d60561c955"
}

variable "instance_type" {
  type = string
  default = "t2.nano"
}

variable "bastion_vpc_security_group_ids" {
  type = list(string)
  default = ["sg-0e97d227aeaba0069"]
}

variable "private_vpc_security_group_ids" {
  type = list(string)
  default = ["sg-0e97d227aeaba0069"]
}

variable "key_name" {
  type = string
  default = "Trainee_key"
}

variable "bastion_name" {
  type = string
  default = "bastion"
}

variable "private_name" {
  type = string
  default = "private"
}

variable "public_subnet_id" {
  type = string
  default = "subnet-07e94f6690884477d"
}

variable "private_subnet_id" {
  type = string
  default = "subnet-07e94f6690884477d"
}

variable "postgres_install_script" {
  type = string
  default = "/home/fulcrum/DevOpsTrainee/Task11/postgres_settings.sh"
}

variable "key_ssh" {
  type = string
  default = "/home/fulcrum/Downloads/Trainee_key.pem"
}

variable "server_key_destination" {
  type = string
  default = "/home/ec2-user/Trainee_key.pem"
}
