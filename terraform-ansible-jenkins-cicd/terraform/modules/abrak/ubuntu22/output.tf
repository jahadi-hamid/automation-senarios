output "details-myabrak-id" {
  value = data.arvan_iaas_abrak.get_abrak_id
}

output "publicip" {
  value = [ 
    for ip in arvan_iaas_abrak.myabrak.addresses:
    ip if ip != arvan_iaas_network_attach.private-network-attach.ip
  ][0]
}

output "privateip" {
  value = arvan_iaas_network_attach.private-network-attach.ip
}
