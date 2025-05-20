variable "private_subnet_id_a" {
  type = string
  default = "subnet-03a52fc6e829f7ef3"
}

variable "private_subnet_id_b" {
  type = string
  default = "subnet-07e94f6690884477d"
}

variable "vpc_id" {
  type = string
  default = "vpc-0daa1f3d3d12069d4"
}

variable "db_username" {
  type = string
  default = "trainee"
}

variable "db_name" {
  type = string
  default = "mydatabase"
}

variable "db_password" {
  type = string
  default = "StrongPass123!"
}

variable "cidr_block_sg_group" {
  type = string
  default = "10.2.2.0/24"
}