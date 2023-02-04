output "cluster-details-myabrak-id" {
  value = module.ubuntu-vm.*.details-myabrak-id.name
}

output "cluster-publicip" {
  value = module.ubuntu-vm.*.publicip
}

output "cluster-privateip" {
  value = module.ubuntu-vm.*.privateip
}

output "cluster-myabrak-publicip" {
  value = module.ubuntu-vm.*.myabrak-publicip
}

output "cluster_name" {
  value = var.cluster_name
  }