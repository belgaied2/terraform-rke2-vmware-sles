module "rancher_virtual_machines" {
  source = "../vsphere"

  vsphere_user = var.vsphere_user
	vsphere_password = var.vsphere_password
	vsphere_server = var.vsphere_server
	vsphere_cluster = var.vsphere_cluster
	vsphere_dc = var.vsphere_dc
	vsphere_datastore = var.vsphere_datastore
	vsphere_network = var.vsphere_network
	vsphere_resource_pool = var.vsphere_resource_pool
	vsphere_template = var.vsphere_template
	node_names = [for i in range(var.node_count) : "${var.node_name_prefix}${i +1}"]
	node_vcpu = var.node_vcpu
	node_memory = var.node_memory
	node_count = var.node_count
	network_gateway = var.network_gateway
	dns_server = var.dns_server
  ad_domain = var.ad_domain
  vm_ip_list = var.rancher_ip_list
  # Building the userdata array 
  list_userdata_b64 = [ for i in range(var.node_count) :

  base64encode(templatefile("${path.module}/templates/${i == 0 ? "cloud_init_first.cfg" : "cloud_init_join.cfg"}", {
      rke2_version = var.rke2_version,
      node_ssh_password = var.node_ssh_password,
      node_ssh_user = var.node_ssh_user,
      node_ssh_key = var.node_ssh_key
      node_name = "${var.node_name_prefix}${i + 1}"
      rke2_token = var.rke2_token
      cni = var.cni
      url = var.url
      ad_domain = var.ad_domain
      ad_username = var.ad_username
      ad_password = var.ad_password
      ad_group = var.ad_group
      init_node_ip = var.rancher_ip_list[0]
    }))
  ]
}

resource "time_sleep" "wait_for_rke2" {
  create_duration = "1m"
  
}

# resource "null_resource" "get_kubeconfig" {

#   provisioner "local-exec" {
#   command = "ssh -i ${var.ssh_private_key} -o StrictHostKeyChecking=no ${var.node_ssh_user}@${var.rancher_ip_list[0]} 'sudo cat /etc/rancher/rke2/rke2.yaml' > /tmp/kube_config_cluster.yml"
#   # command = "ssh -i ${var.ssh_private_key} -o StrictHostKeyChecking=no ${var.node_ssh_user}@${var.rancher_ip_list[0]} 'sudo cat /etc/rancher/rke2/rke2.yaml' > kube_config_cluster.yml && chmod 0600 kube_config_cluster.yml"
#   }

#   # provisioner "local-exec" {
#   # command = "sed -i 's|127.0.0.1|${var.url}|g' ${path.root}/kube_config_cluster.yml"
#   # }

#   provisioner "local-exec" {
#     when = destroy
#     command = "rm -f /tmp/kube_config_cluster.yml"
#   }
#   depends_on = [ time_sleep.wait_for_rke2 ]
# }

data "remote_file" "get_kubeconfig" {
  conn {
    host = var.rancher_ip_list[0]
    port = 22
    user= var.node_ssh_user
    # password = var.node_ssh_password
    private_key_path = "/home/mohamed/.ssh/id_rsa"
    # private_key_path = var.ssh_private_key
    sudo = true
  }
  path = "/etc/rancher/rke2/rke2.yaml"

  depends_on = [time_sleep.wait_for_rke2]
}

output "kubeconfig" {
  value = yamldecode(data.remote_file.get_kubeconfig.content) 
}

resource "time_sleep" "wait_for_kubeconfig" {
  depends_on = [data.remote_file.get_kubeconfig]
  create_duration = "1m"
  
}

# resource "null_resource" "check_access" {


#   provisioner "local-exec" {
#   command = "kubectl --kubeconfig=${path.root}/kube_config_cluster.yml get nodes"
#   }

#   depends_on = [time_sleep.wait_for_kubeconfig]
# }