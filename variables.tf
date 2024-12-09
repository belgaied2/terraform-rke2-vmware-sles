variable node_count {
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

variable node_name {
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

variable "ssh_key_file" {
    type = string
    description = "ssh key"
    default = "~/.ssh/id_rsa"
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