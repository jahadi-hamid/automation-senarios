module "abrak-ssh-net-module" {
  net-ssh-region = var.region
  source         = "./modules/ssh-prvnetwork"
  subnet_name    = var.cluster_name
  ip_range       = var.ip_range
  ssh-public_key = file("${var.key_path}.pub")
}

module "abrak-module" {
  count        = var.server-num
  abrak-region = var.region
  source       = "./modules/abrak/ubuntu22"
  depends_on = [
    module.abrak-ssh-net-module
  ]
  abrak-number = count.index
  abrak-name   = "${var.cluster_name}-${count.index}"
  ssh-keyname  = module.abrak-ssh-net-module.get-ssh-key.name
  network_uuid = module.abrak-ssh-net-module.subnet-details.network_uuid
  ip_range     = var.ip_range
}

/* # add extra public ip
module "abrak-public-ip-module" {
  source = "./modules/public-ip"
  depends_on = [
    module.abrak-module
  ]
  region-publicip = var.region
  myabrak_uuid    = module.abrak-module.details-myabrak-id.id
}
 */




resource "local_file" "minio_hosts" {
  depends_on = [
    module.abrak-module
  ]
  filename = "../ansible/setup-minio/files/minio.hosts"
  content = templatefile("minio.hosts.tmpl",
    {
      minio_hostname = module.abrak-module.*.details-myabrak-id.name,
      minio_prvip    = module.abrak-module.*.privateip,
    }
  )
}

resource "local_file" "ansible_inventory" {
  depends_on = [
    module.abrak-module
  ]
  filename = "inventory"
  content = templatefile("inventory.tmpl",
    {
      ansible_ip       = module.abrak-module.*.publicip,
      ansible_hostname = module.abrak-module.*.details-myabrak-id.name,
      ansible_prvip    = module.abrak-module.*.privateip,
      key_path         = var.key_path
      username         = var.user_name
    }
  )
   provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory ../ansible/setup-minio.yml "
  } 
}