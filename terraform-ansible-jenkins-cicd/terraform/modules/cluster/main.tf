module "ubuntu-vm" {
  count = var.cluster_number
  ip_index = var.cluster_ip_index
  abrak-region = var.cluster_region
  source       = "../abrak/ubuntu22"
  abrak-number = count.index
  abrak-name   = "${var.cluster_name}-${count.index}"
  ssh-keyname  = var.cluster_ssh-keyname
  network_uuid = var.cluster_network_uuid
  ip_range     = var.ip_range
  extraip = false
}

# resource "local_file" "vm_hosts" {
#     count =  var.cluster_number > 0 ? 1 : 0
#     depends_on = [
#       module.ubuntu-vm
#     ]
#   filename = "${var.home_project}/ansible/setup-${var.cluster_name}/files/${var.cluster_name}.hosts"
#   content = templatefile("../templates/hosts.tmpl",
#     {
#       vm_hostname = [for vm in module.ubuntu-vm : vm.details-myabrak-id.name],
#       vm_prvip    = [for vm in module.ubuntu-vm : vm.privateip],
#     }
#   )
# }

# resource "time_sleep" "wait_60_seconds" {
#   depends_on = [local_file.vm_hosts]

#   create_duration = "60s"
# }

resource "local_file" "ansible_inventory" {
    count =  var.cluster_number > 0 ? 1 : 0
    depends_on = [
      module.ubuntu-vm,
      local_file.vm_hosts
    ]
  filename = "${var.home_project}/ansible/setup-${var.cluster_name}/inventory"
  content = templatefile("../templates/inventory.tmpl",
    {
      ansible_groupname= var.cluster_name,
      ansible_ip       = module.ubuntu-vm.*.publicip,
      ansible_hostname = module.ubuntu-vm.*.details-myabrak-id.name,
      ansible_prvip    = module.ubuntu-vm.*.privateip,
      key_path         = var.cluster_key_path 
      username         = var.cluster_user_name 
    }
  )
#     provisioner "local-exec" {
#      command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${var.home_project}/ansible/setup-${var.cluster_name}/inventory ${var.home_project}/ansible/setup-${var.cluster_name}.yml "
#    } 
}