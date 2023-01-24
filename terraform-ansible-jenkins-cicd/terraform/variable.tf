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
variable "server-num" {
  type    = number
  default = 4
}
variable "user_name" {
  type    = string
  default = "ubuntu"
}
variable "cluster_name" {
  type    = string
  default = "minio"
}
variable "ip_range" {
  type    = string
  default = "192.168.10.0/24"
}