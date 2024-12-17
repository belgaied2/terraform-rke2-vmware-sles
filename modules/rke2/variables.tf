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

variable "rmt_server" {
  description = "RMT server"
  type        = string
  
}

variable "rmt_fingerprint" {
  description = "RMT fingerprint"
  type        = string
  
}

variable "hosted_registry" {
  description = "Hosted registry"
  type        = string
  
}

variable "hosted_registry_port" {
  description = "Hosted registry port"
  type        = string
  
}

variable "mirror_port" {
  description = "Mirror port"
  type        = string
  
}

variable "hosted_registry_username" {
  description = "Hosted registry username"
  type        = string
  
}

variable "hosted_registry_password" {
  description = "Hosted registry password"
  type        = string
  
}

variable "mirror_username" {
  description = "Mirror username"
  type        = string
  
}

variable "mirror_password" {
  description = "Mirror password"
  type        = string
  
}

variable "ssh_private_key_path" {
  description = "Path to the private key"
  type        = string
}

variable "binary_images" {
  description = "List of binary images to pull"
  type        = list(string)
  
}