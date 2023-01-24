variable "net-ssh-region" {
  type = string
}
variable "subnet_name" {
  type = string
}
variable "ip_range" {
  type    = string
  default = "192.168.0.0/24"
}

variable "ssh-public_key" {
  type = string
}