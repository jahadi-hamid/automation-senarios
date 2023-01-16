terraform {
  required_providers {
    arvan = {
      source  = "arvancloud/arvan"
      version = "0.6.4" # put the version here
    }
  }
}

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
  default = "g2-1-1-0"
}
variable "ssh-keyname" {
  type = string
}
variable "network_uuid" {
  type = string
}
variable "ip_range" {

}

resource "arvan_iaas_abrak" "myabrak" {
  region = var.abrak-region
  flavor = var.abrak-plan
  name   = var.abrak-name
  image {
    type = "distributions"
    name = "${var.os-distro}/${var.os-version}"
  }
  disk_size = var.disksize
  ssh_key   = true
  key_name  = var.ssh-keyname
}


resource "arvan_iaas_network_attach" "private-network-attach" {

  region       = var.abrak-region
  abrak_uuid   = data.arvan_iaas_abrak.get_abrak_id.id
  network_uuid = var.network_uuid
  ip           = cidrhost("${var.ip_range}", "${var.abrak-number + 2}")

}