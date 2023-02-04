output "cluster_hostnames-ips" {
  value = [
    for index, v in module.cluster-vm.* : {
      "name" : v.*.cluster-details-myabrak-id  
      "public-ip" : v.*.cluster-publicip
      "private-ip" : v.*.cluster-privateip
    }
  ]
}

