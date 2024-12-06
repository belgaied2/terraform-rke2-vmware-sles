locals {
  node_command = rancher2_cluster_v2.custom_cluster_vsphere.cluster_registration_token[0].insecure_node_command

}

resource "rancher2_cluster_v2" "custom_cluster_vsphere" {
  name = var.cluster_name
  kubernetes_version = var.k8s_version
  
}

module "custom_cluster_virtual_machines" {
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
	node_names = [for i in range (var.node_count) : "${var.node_name_prefix}${i < 3 ? "-CP${i}" : "-WK${i - 2}"}"
]
	node_vcpu = var.node_vcpu
	node_memory = var.node_memory
	node_count = var.node_count
	network_gateway = var.network_gateway
	dns_server = var.dns_server
  ad_domain = var.ad_domain
  vm_ip_list = var.downstream_ip_list
  # Building the userdata array 
  list_userdata_b64 = [ for i in range(var.node_count) :

  base64encode(templatefile("${path.module}/templates/cloud_init_custom.cfg", {
      node_ssh_password = var.node_ssh_password,
      node_ssh_user = var.node_ssh_user,
      node_ssh_key = var.node_ssh_key
      node_name = "${var.node_name_prefix}${i < 3 ? "-CP${i}" : "-WK${i - 2}"}"
      ad_domain = var.ad_domain
      ad_username = var.ad_username
      ad_password = var.ad_password
      ad_group = var.ad_group
      node_command = "${local.node_command} --worker ${i < 3 ? " --controlplane --etcd" : ""}"
    }))
  ] 
}