# resource "local_file" "private_ip_hosts" {
#   filename = "${var.home_project}/ansible/setup-minio/files/minio.hosts"
#   content = templatefile("../templates/minio.hosts.tmpl",
#     {
#       hosts_hostname = ["${var.module_hostnames}"],
#       hosts_prvip    = ["${var.module_prvips}"]
#     }
#   )
# }

# resource "local_file" "ansible_inventory" {
#   filename = "inventory"
#   content = templatefile("templates/inventory.tmpl",
#     {
#       ansible_ip       = var.module_out.*.publicip,
#       ansible_hostname = var.module_out.*.details-myabrak-id.name,
#       ansible_prvip    = var.module_out.*.privateip,
#       key_path         = var.key_path
#       username         = var.user_name
#     }
#   )
#   #  provisioner "local-exec" {
#   #   command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory ${var.home_project}/ansible/setup-minio.yml "
#   # } 
# }