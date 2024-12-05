data "vsphere_datacenter" "dc" {
  name = var.vsphere_dc
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  count = var.vsphere_resource_pool == "" ? 0 : 1
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}


data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}
 
data "vsphere_virtual_machine" "template" {
  name          = var.vsphere_template 
  datacenter_id = data.vsphere_datacenter.dc.id
}

locals {
  node_command = rancher2_cluster_v2.custom_cluster_vsphere.cluster_registration_token[0].insecure_node_command

}