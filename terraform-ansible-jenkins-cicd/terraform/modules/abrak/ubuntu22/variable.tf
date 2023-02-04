variable "abrak-number" {
  type = number
}
variable "abrak-name" {
  type = string
}
variable "abrak-region" {
  type = string
}
variable "os-distro" {
  type    = string
  default = "ubuntu"
}
variable "os-version" {
  type    = string
  default = "22.04"
}
variable "disksize" {
  type    = number
  default = 25
}
variable "abrak-plan" {
  type    = string
  default = "g2-2-2-0"
}
variable "ssh-keyname" {
  type = string
}
variable "network_uuid" {
  type = string
}
variable "ip_range" {

}
variable "extraip" {
  type = bool
}
variable "ip_index" {
  type = number
}
