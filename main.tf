
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


module "rancher" {
  providers = {
    rancher2 = rancher2.bootstrap
  }
	source = "./modules/rancher"
	url = var.url
  rancher_password = var.rancher_password
  rancher_bootstrap_password = var.rancher_bootstrap_password
	depends_on = [module.rke2]
}
# module "rancher" {
# 	source = "./modules/rancher"
# 	url = var.url
#	rancher_bootstrap_password = var.rancher_bootstrap_password
#	rancher_admin_password = var.rancher_admin_password
#
# 	depends_on = [module.rke2]
# }

module "custom_cluster" {
  providers = {
    rancher2 = rancher2.admin
  }

  source = "./modules/custom"
  node_count = var.node_count
  node_memory = var.node_memory
  node_vcpu = var.node_vcpu
  node_prefix = "CND-BKD-TST-TC"
  disk_size = ""
  vsphere_resource_pool = ""
  vsphere_dc = var.vsphere_dc
  vsphere_datastore = var.vsphere_datastore
  vsphere_network = var.vsphere_network
  vsphere_cluster = var.vsphere_cluster
  ad_domain = var.ad_domain
  ad_username = var.ad_username
  ad_password = var.ad_password
  ad_group = var.ad_group
  node_ssh_user = var.ssh_user
  node_ssh_password = var.ssh_password
  time_zone = "Europe/Berlin"
  ipv4_gateway = var.network_gateway
  dns_server = var.dns_server
  first_node_ip = "10.29.226.232"
  vsphere_template = var.vsphere_template
  node_ssh_key = var.ssh_key
  cluster_name = "cnd4-test-cluster"
  cluster_description = "Test RKE2 Cluster for CND4"
  k8s_version = var.rke2_version
}