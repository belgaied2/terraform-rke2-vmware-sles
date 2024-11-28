
module "vsphere" {
	source = "./modules/vsphere"
	vsphere_user = var.vsphere_user
	vsphere_password = var.vsphere_password
	vsphere_server = var.vsphere_server
	vsphere_cluster = var.vsphere_cluster
	vsphere_dc = var.vsphere_dc
	vsphere_datastore = var.vsphere_datastore
	vsphere_network = var.vsphere_network
	vsphere_resource_pool = var.vsphere_resource_pool
	vsphere_template = var.vsphere_template
	node_name = var.node_name
	node_vcpu = var.node_vcpu
	node_memory = var.node_memory
	node_ssh_key = var.ssh_key
	node_ssh_user = var.ssh_user
  node_ssh_password = var.ssh_password
	node_count = var.node_count
	ssh_private_key = var.ssh_private_key
	rke2_token = var.rke2_token
	cni = var.cni
	url = var.url
	lb_memory = var.lb_memory
	lb_vcpu = var.lb_vcpu
	lb_ssh_key = var.ssh_key
	lb_ssh_user = var.ssh_user
	lb_name = var.lb_name
	lb_ip = var.lb_ip
	subnet_mask = var.subnet_mask
	network_gateway = var.network_gateway
	registration_key = var.registration_key
	dns_server = var.dns_server
	nodes_ip = var.nodes_ip
	main_ip = var.main_ip
	rke2_version = var.rke2_version
  ad_username = var.ad_username
  ad_password = var.ad_password
  ad_domain = var.ad_domain
  ad_group = var.ad_group
}


module "rke2" {
	source = "./modules/rke2"
	nodes_ip = var.nodes_ip
	main_ip = var.main_ip
	node_ssh_user = var.ssh_user
	ssh_private_key = var.ssh_private_key
	url = var.main_ip
	depends_on = [module.vsphere]
}


# module "rancher" {
# 	source = "./modules/rancher"
# 	url = var.url
# 	depends_on = [module.rke2]
# }

