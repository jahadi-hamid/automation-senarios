variable "ApiKey" {
  type      = string
  sensitive = true
}
variable "region" {
  type    = string
  default = "ir-thr-w1"
}

variable "ip_range" {
  type    = string
  default = "192.168.10.0/24"
}
variable "key_path" {
  type    = string
  default = "/root/.ssh/arvan_rsa"
}

variable "user_name" {
  type    = string
  default = "ubuntu"
}

variable "home_project" {
  type = string
  default = "/home/hamidj/MyGitRepo/automation-senarios/terraform-ansible-jenkins-cicd"
}

variable "cluster_ip_index" {
  type = number
  default = 0
}
