variable "ApiKey" {
  type      = string
  default   = "Apikey ***"
  sensitive = true
}
variable "region" {
  type    = string
  default = "ir-thr-c1"
}
variable "key_path" {
  type    = string
  default = "/root/.ssh/arvan_rsa"
}

variable "user_name" {
  type    = string
  default = "ubuntu"
}

variable "ip_range" {
  type    = string
  default = "192.168.10.0/24"
}
variable "home_project" {
  type = string
  default = "/home/h.jahadi/MyGitRepo/automation-senarios/terraform-ansible-jenkins-cicd"
}