module "infra-ssh-net-module" {
  net-ssh-region = var.region
  source         = "../modules/ssh-prvnetwork"
  subnet_name    = "minio-project"
  ip_range       = var.ip_range
  ssh-public_key = file("${var.key_path}.pub")
}

## create minio nodes & install and configure servers
locals {
  module_instances = [{
      name = "minio" 
      count = 4
    },
    {
      name = "jenkins" 
      count = 0
    },
    {
      name = "minio" 
      count = 4
    }
  ]

  instance_count = [for object in local.module_instances : object.count]
}


module "cluster-vm" {
  count = length(local.module_instances)
  cluster_ip_index = count.index > 0 ? sum(slice(local.instance_count, 0, count.index   )) : 0
  cluster_name = local.module_instances[count.index].name
  cluster_number = local.module_instances[count.index].count
  cluster_region = var.region
  ip_range = var.ip_range
  home_project = var.home_project
  cluster_key_path = var.key_path
  cluster_user_name = var.user_name
  cluster_ssh-keyname  = module.infra-ssh-net-module.get-ssh-key.name
  cluster_network_uuid = module.infra-ssh-net-module.subnet-details.network_uuid
  source       = "../modules/cluster"
  depends_on = [
    module.infra-ssh-net-module
  ]

}

resource "time_sleep" "wait_60_seconds" {
  depends_on = [module.cluster-vm]

  create_duration = "60s"
}

resource "null_resource" "ansible_run" {
  depends_on = [time_sleep.wait_60_seconds]
  count = length([for cluster in module.cluster-vm : cluster.cluster_name if length(cluster.cluster-publicip) > 0 ])

    provisioner "local-exec" {
     command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${var.home_project}/ansible/setup-${[for cluster in module.cluster-vm : cluster.cluster_name if length(cluster.cluster-publicip) > 0 ][count.index]}/inventory ${var.home_project}/ansible/setup-${[for cluster in module.cluster-vm : cluster.cluster_name if length(cluster.cluster-publicip) > 0 ][count.index]}.yml "
   } 
}
