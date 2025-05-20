variable "ssh_access" {
  type = object({
    cidr_block = string
    rule_name  = string
  })
  description = "SSH access"
  default = {
    cidr_block = "0.0.0.0/0"
    rule_name  = "SSH"
  }

}