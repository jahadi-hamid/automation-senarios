output "hostnames-ips" {
  value = [
    for index, v in module.abrak-module.* :
    { "server-ip" : v.publicip,
      "server-name" : module.abrak-module[index].details-myabrak-id.name
    }
  ]


}

