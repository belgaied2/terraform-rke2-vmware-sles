
# module "vsphere" {
# 	source = "./modules/vsphere"
# 	vsphere_user = var.vsphere_user
# 	vsphere_password = var.vsphere_password
# 	vsphere_server = var.vsphere_server
# 	vsphere_cluster = var.vsphere_cluster
# 	vsphere_dc = var.vsphere_dc
# 	vsphere_datastore = var.vsphere_datastore
# 	vsphere_network = var.vsphere_network
# 	vsphere_resource_pool = var.vsphere_resource_pool
# 	vsphere_template = var.vsphere_template
# 	node_name = var.node_name
# 	node_vcpu = var.node_vcpu
# 	node_memory = var.node_memory
# 	node_ssh_key = var.ssh_key
# 	node_ssh_user = var.ssh_user
#   node_ssh_password = var.ssh_password
# 	node_count = var.node_count
# 	ssh_private_key = var.ssh_private_key
# 	rke2_token = var.rke2_token
# 	cni = var.cni
# 	url = var.url
# 	subnet_mask = var.subnet_mask
# 	network_gateway = var.network_gateway
# 	registration_key = var.registration_key
# 	dns_server = var.dns_server
# 	nodes_ip = var.nodes_ip
# 	main_ip = var.main_ip
# 	rke2_version = var.rke2_version
#   ad_username = var.ad_username
#   ad_password = var.ad_password
#   ad_domain = var.ad_domain
#   ad_group = var.ad_group
# }


module "rke2" {
	source = "./modules/rke2"
	node_ssh_user = var.ssh_user
	ssh_private_key = var.ssh_key_file
	url = var.lb_ip
  rancher_ip_list = var.nodes_ip
  vsphere_cluster = var.vsphere_cluster
  vsphere_server = var.vsphere_server
  vsphere_user = var.vsphere_user
  vsphere_password = var.vsphere_password
  vsphere_dc = var.vsphere_dc
  vsphere_datastore = var.vsphere_datastore
  vsphere_network = var.vsphere_network
  vsphere_resource_pool = var.vsphere_resource_pool
  vsphere_template = var.vsphere_template
  node_vcpu = var.node_vcpu
  node_memory = var.node_memory

  ad_domain = var.ad_domain
  ad_username = var.ad_username
  ad_password = var.ad_password
  ad_group = var.ad_group

  rke2_version = var.rke2_version
  node_ssh_password = var.ssh_password
  cni = var.cni
  rke2_token = var.rke2_token
  network_gateway = var.network_gateway
  node_name_prefix = "CND-BKD-RC"
  node_count = 3
  node_ssh_key = var.ssh_key
  dns_server = var.dns_server


}


module "rancher" {
  providers = {
    rancher2 = rancher2.bootstrap
  }
	source = "./modules/rancher"
	url = var.url
  rancher_password = var.rancher_password
  rancher_bootstrap_password = var.rancher_bootstrap_password
  ad_password_admin = var.ad_password_admin
  ad_searchbase = var.ad_searchbase
  ad_username_admin = var.ad_username_admin
  ad_username_browse = var.ad_username_browse
  ad_password_browse = var.ad_password_browse
  ad_domain = var.ad_domain
  app_git_repo_url = var.app_git_repo_url
  app_git_path = var.app_git_path
  app_name = var.app_name
  repo_branch = var.repo_branch
	depends_on = [module.rke2]
  cluster_name = "cnd4-test-cluster"
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

  source = "./modules/custom_cluster"
  node_count = 5
  node_memory = var.node_memory
  node_vcpu = var.node_vcpu
  node_name_prefix = "CND-BKD-TST-TC"
  disk_size = ""
  vsphere_resource_pool = ""
  vsphere_server = var.vsphere_server
  vsphere_user = var.vsphere_user
  vsphere_password = var.vsphere_password
  vsphere_dc = var.vsphere_dc
  vsphere_datastore = var.vsphere_datastore
  vsphere_network = var.vsphere_network
  vsphere_cluster = var.vsphere_cluster
  network_gateway = var.network_gateway
  rke2_version = var.rke2_version
  downstream_ip_list = [for i in range(232, 237) : "10.29.226.${i}"]
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
  vip_address = var.vip_address
  interface_vip = var.interface_vip
  vip_cidr = var.vip_cidr
}

# Create a new rancher2 Auth Config ActiveDirectory
resource "rancher2_auth_config_activedirectory" "activedirectory" {
  provider = rancher2.admin
  servers = [var.ad_server]
  service_account_username = var.ad_username_browse
  service_account_password = var.ad_password_browse
  user_search_base = var.ad_searchbase
  port = var.ad_port
  test_username = var.ad_username_admin
  test_password = var.ad_password_admin
}