output "minio_cluster_hostnames-ips" {
  value = [
    for index, v in module.minio-cluster.* :
    { "server-ip" : v.publicip,
      "server-name" : module.minio-cluster[index].details-myabrak-id.name
    }
  ]
}

output "jenkins_hostnames-ips" {
  value = [
    for index, v in module.jenkins-vm.* :
    { "server-ip" : v.publicip,
      "server-name" : module.jenkins-vm[index].details-myabrak-id.name
    }
  ]
}