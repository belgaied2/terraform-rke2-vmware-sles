variable "ssh_private_key"{
    type = string
    description = "Location of the private key to connect to the host"
}


variable "url" {
    type = string
    description = "url to reach the loadbalancer (must have been setup on your host machine)"
}

variable "vsphere_user" {
  type = string
  description = "Username for the vcenter"
}
variable "vsphere_password" {
  type = string
  description = "Vsphere password"
}
variable "vsphere_server" {
  type = string
  description = "Vcenter Server address"
}
variable "vsphere_cluster" {
  type = string
  description = "vSphere Cluster name"
}
variable "vsphere_dc" {
  type = string
  description = "vSphere Datacenter Name"
}
variable "vsphere_datastore" {
  type = string
  description = "vSphere Datastore Name"
}
variable "vsphere_network" {
  type = string
  description = "vSphere Network Name"
}
variable "vsphere_resource_pool" {
  type = string
  description = "vSphere Resource Pool Name"
}
variable "vsphere_template" {
  type = string
  description = "Name of the template to use to create VMS"
}
variable "node_vcpu" {
  type = number
  description = "Number of vCPUs for the VM"
}
variable "node_memory" {
  type = number
  description = "Amount of memory for the VM"
}
variable "node_count" {
  type = number
  description = "Number of nodes to provision"
  default = 3
}
variable "network_gateway" {
  type = string
  description = "Network Gateway"
}
variable "dns_server" {
  type = string
  description = "DNS Server"
}
variable "ad_domain" {
  type = string
  description = "Active Directory Domain"
}
variable "rancher_ip_list" {
  type = list(string)
  description = "List of IP addresses for the Rancher nodes"
}

variable "node_ssh_password" {
  type = string
  description = "Password for the node"
}

variable "node_ssh_user" {
  type = string
  description = "Username for the node"
}

variable "node_ssh_key" {
  type = string
  description = "SSH key for the node"
}

variable "node_name_prefix" {
  type = string
  description = "Prefix for the node name"
  
}

variable "rke2_token" {
  type = string
  description = "RKE2 token"
  
}

variable "rke2_version" {
  type = string
  description = "RKE2 version"
  
}

variable "cni" {
  type = string
  description = "CNI plugin to use"
  
}

variable "ad_username" {
  type = string
  description = "Active Directory Username"
  
}

variable "ad_password" {
  type = string
  description = "Active Directory Password"
  
}

variable "ad_group" {
  type = string
  description = "Active Directory Group"
  
}