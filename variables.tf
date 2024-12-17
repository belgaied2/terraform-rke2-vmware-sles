variable rancher_node_count {
  type        = number
  description = "Number of nodes to be provisioned"
}

variable node_memory {
  type        = string
  description = "The amount of RAM for each nodes"
}

variable node_vcpu {
  type        = number
  description = "Number of vcpu for the nodes"
}

variable rancher_node_name_prefix {
  type        = string
  description = "Node names"
}

variable ssh_key {
  type        = string
  description = "SSH key to add to the cloud-init for user access"
}

variable ssh_user {
  type        = string
  description = "SSH user to use"
}

variable ssh_password {
  type        = string
  description = "SSH password to add to the cloud-init for user access"
}

variable "subnet_mask" {
  type = string
  description = "Hostname used for the loadbalancer"
  
}

variable "network_gateway" { 
  type = string
  description = "Network gateway Ip address."
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
  description = "Vcenter address"
}


variable "vsphere_dc" {
  type = string
  description = "Vcenter Datacenter Name"
}


variable "vsphere_cluster" {
  type = string
  description = "Cluster name"
  
}

variable "vsphere_datastore" {
    type = string
    description = "Datastore Name"
}


variable "vsphere_network" {
    type = string
    description = "Network Name"
}

variable "vsphere_resource_pool" {
    type = string
    description = "Resource pool name"
}

variable "vsphere_template" {
    type = string
    description = "Name of the template to use to create VMS"
}


variable "rke2_token" {
  type = string
  description = "RKE2 Cluster token"
}



variable "cni" {
  type = string
  description = "CNI"
}


variable "registration_key" { 
  type = string
  description = "Suse Registration Key"
}

variable "dns_server" {
    type = string
    description = "Ips of dns server"
}



variable "lb_ip" {
    type = string
    description = "VIP for the loadbalancer"
}


variable "nodes_ip" {
    type = list
    description = "join nodes IPs"
}


variable "rke2_version" {
    type = string
    description = "RKE2 version"
}

variable "ad_domain" {
    type = string
    description = "Active Directory domain"
  
}

variable "ad_username" {
    type = string
    description = "Active Directory username"
  
}

variable "ad_password" {
    type = string
    description = "Active Directory password"
    default = ""
  
}

variable "ad_group" {
  type = string
  description = "Active Directory group"
}

variable "rancher_password" {
  type = string
  description = "Rancher admin's password"
}

variable "rancher_bootstrap_password" {
  type = string
  description = "Rancher bootstrap password"
  
  sensitive = true 
}


variable "vip_address" {
  description = "VIP ip address"
  type = string  
}

variable "vip_cidr" {
  description = "VIP CIDR"
  type = number
  default = 32
}

variable "interface_vip" {
  description = "VIP network interface"
  type = string
}


variable "ad_searchbase" {
  type = string
  description = "User search base DN"
}



variable "ad_username_admin" {
  type = string
  description = "Active Directory username"

}

variable "ad_password_admin" {
  type = string
  description = "Active Directory password"
  default = ""
  sensitive = true 

}

variable "ad_password_browse" {
  type = string
  description = "Active directory password for the discovery user"
  sensitive = true 

}

variable "ad_username_browse" {
type = string
description = "Active directory user for discovery"  
}

variable "ad_server" {
  type = string
  description = "Active Directory server"
}

variable "ad_port" {
  type = number
  description = "Active Directory port"
  default = 389
  
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
  type = string
  description = "Hosted registry"
  
}

variable "hosted_registry_port" {
  type = number
  description = "Hosted registry port"
  default = 5000
  
}

variable "hosted_registry_username" {
  type = string
  description = "Hosted registry username"
  
}

variable "hosted_registry_password" {
  type = string
  description = "Hosted registry password"
  sensitive = true 
}

variable "mirror_port" {
  type = number
  description = "Mirror port"
  default = 5007
  
}

variable "mirror_username" {
  type = string
  description = "Mirror username"
  
}

variable "mirror_password" {
  type = string
  description = "Mirror password"
  sensitive = true 
}

variable "rancher_helm_hosted_repository" {
  type = string
  description = "Repository in the hosted registry for the Rancher OCI Helm chart"
  
}

variable "rancher_helm_tag" {
  type = string
  description = "OCI tag for the Rancher Helm chart"
  
}

variable "rke2_binary_repos" {
  type = list(string)
  description = "List of binary file repos to pull from registry"
}

variable "app_git_repo_url" {
  type = string
  description = "Git repository URL for fleet"
  }

variable "app_git_path" {
  type = string
  description = "Repository subpath if needed"
  default = ""
}

variable "repo_branch" {
  type = string
  description = "Branch from where to pull the app"
  default = "main"
}

variable "app_name" {
  type = string
  description = "Application name"
}