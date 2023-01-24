resource "arvan_iaas_sshkey" "myabrak-sshkey" {
  region     = var.net-ssh-region
  name       = "ssh-ubuntu-user"
  public_key = var.ssh-public_key
}

resource "arvan_iaas_subnet" "mysubnet" {
  region         = var.net-ssh-region
  name           = "${var.subnet_name}-subnet"
  subnet_ip      = var.ip_range
  enable_gateway = false
  #gateway = cidrhost(var.ip_range,1)
  dns_servers = [
    "8.8.8.8",
    "4.2.2.4"
  ]
  enable_dhcp = false
}

resource "arvan_iaas_abrak_action" "myabrak-publicip" {
  count =  var.extraip ? 1 : 0
  action     = "add-public-ip"
  region     = var.region-publicip
  abrak_uuid = var.myabrak_uuid
}