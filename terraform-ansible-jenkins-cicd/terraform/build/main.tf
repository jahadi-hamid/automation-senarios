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
      count = 1
    },
    {
      name = "worker" 
      count = 0
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

# module "minio-cluster" {
#   count        = 1
#   abrak-region = var.region
#   source       = "../modules/abrak/ubuntu22"
#   depends_on = [
#     module.infra-ssh-net-module
#   ]
#   abrak-number = count.index
#   abrak-name   = "minio-${count.index}"
#   ssh-keyname  = module.infra-ssh-net-module.get-ssh-key.name
#   network_uuid = module.infra-ssh-net-module.subnet-details.network_uuid
#   ip_range     = var.ip_range
#   extraip = false
# }

# resource "local_file" "minio_hosts" {
#   filename = "${var.home_project}/ansible/setup-minio/files/minio.hosts"
#   content = templatefile("../templates/minio.hosts.tmpl",
#     {
#       minio_hostname = module.minio-cluster.*.details-myabrak-id.name,
#       minio_prvip    = module.minio-cluster.*.privateip,
#     }
#   )
# }

# resource "local_file" "minio_ansible_inventory" {
#   filename = "${var.home_project}/ansible/setup-minio/inventory"
#   content = templatefile("../templates/inventory.tmpl",
#     {
#       ansible_ip       = module.minio-cluster.*.publicip,
#       ansible_hostname = module.minio-cluster.*.details-myabrak-id.name,
#       ansible_prvip    = module.minio-cluster.*.privateip,
#       key_path         = var.key_path
#       username         = var.user_name
#     }
#   )
#   #  provisioner "local-exec" {
#   #   command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${var.home_project}/ansible/setup-minio/inventory ${var.home_project}/ansible/setup-minio.yml "
#   # } 
# }

## create and install jenkins machine

# module "jenkins-vm" {
#   count        = 1
#   abrak-region = var.region
#   source       = "../modules/abrak/ubuntu22"
#   depends_on = [
#     module.infra-ssh-net-module
#   ]
#   abrak-number = count.index
#   abrak-name   = "jenkins-${count.index}"
#   ssh-keyname  = module.infra-ssh-net-module.get-ssh-key.name
#   network_uuid = module.infra-ssh-net-module.subnet-details.network_uuid
#   ip_range     = var.ip_range
#   os-version   = "20.04"
#   extraip = false
# }

# resource "local_file" "jenkins_ansible_inventory" {
#   filename = "${var.home_project}/ansible/setup-jenkins/inventory"
#   content = templatefile("../templates/inventory.tmpl",
#     {
#       ansible_ip       = module.jenkins-vm.*.publicip,
#       ansible_hostname = module.jenkins-vm.*.details-myabrak-id.name,
#       ansible_prvip    = module.jenkins-vm.*.privateip,
#       key_path         = var.key_path
#       username         = var.user_name
#     }
#   )

# }




# module "minio-pre-automation" {
#     depends_on = [
#     module.minio-cluster
#   ]
#   source         = "../modules/output_infra_automation"
#   key_path = var.key_path
#   user_name = var.user_name
#   module_hostnames = "${module.minio-cluster.*.details-myabrak-id.name}"
#   module_prvips = ["${module.minio-cluster.*.privateip}"]
#   module_pubips = ["${module.minio-cluster.*.publicip}"]
#   home_project  = var.home_project
# }