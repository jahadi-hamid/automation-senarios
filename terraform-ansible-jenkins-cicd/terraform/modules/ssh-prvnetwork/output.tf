output "mynet-ip-range" {
  value = var.ip_range
}

output "subnet-details" {
  value = arvan_iaas_subnet.mysubnet
}

output "get-ssh-key" {
  value = arvan_iaas_sshkey.myabrak-sshkey
}