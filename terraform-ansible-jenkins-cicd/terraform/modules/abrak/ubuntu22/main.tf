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

resource "arvan_iaas_abrak_action" "myabrak-extrapublicip" {
  count =  var.extraip ? 1 : 0
  action     = "add-public-ip"
  region     = var.abrak-region
  abrak_uuid = data.arvan_iaas_abrak.get_abrak_id.id
}