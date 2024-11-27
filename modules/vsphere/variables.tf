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

variable "node_count"{
    type = number
    description = "Number of nodes to provision"
}

variable "node_name" {
    type = string
    description = "VM name"
}


variable "node_vcpu" {
    type = number
    description = "Number of cpu per nodes"  
}

variable "node_memory" {
  type = string
  description = "Amount of memory to be allocated to the VM"
}

variable "node_ssh_key" {
    type = string
    description = "ssh_Key"
}

variable "node_ssh_user" {
    type = string
    description = "node username"
}
variable "node_ssh_password" {
    type = string
    description = "node ssh password"
}


variable "ssh_private_key"{
    type = string
    description = "Location of the private key to connect to the host"
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

variable "url" {
    type = string
    description = "url to reach the loadbalancer (must have been setup on your host machine)"
}



variable lb_memory {
  type        = string
  default     = 2048
  description = "The amount of RAM for the loadbalancer"
}

variable lb_vcpu {
  type        = number
  description = "Number of vcpu for the lb"
}


variable lb_ssh_key {
  type        = string
  description = "SSH key to add to the cloud-init for user access"
}

variable lb_ssh_user {
    type        = string
    description = "SSH user for the loadbalancer"
}


variable "lb_name" {
  type = string
  description = "Hostname used for the loadbalancer"
  
}

variable "lb_ip" {
type = string
description = "Loadbalancer's ip"
}



variable "subnet_mask" {
  type = string
  description = "Hostname used for the loadbalancer"
  
}

variable "network_gateway" { 
  type = string
  description = "Network gateway Ip address."
}


variable "registration_key" { 
  type = string
  description = "Suse Registration Key"
}


variable "dns_server" {
    type = string
    description = "Ips of the nodes"
}

variable "main_ip" {
    type = string
    description = "main server IP"
}


variable "nodes_ip" {
    type = list
    description = "nodes IPs - list"
}


variable "rke2_version" {
    type = string
    description = "Version of RKE2 to install"
}

variable "ntp_server" {
    type = string
    description = "NTP server"  
    default = ""
}

variable "ad_username" {
  type = string
  description = "Active Directory username"
}

variable "ad_password" {
  type = string
  description = "Active Directory password"
}

variable "ad_domain" {
  type = string
  description = "Active Directory domain"
  
}

variable "ad_group" {
  type = string
  description = "Active Directory group"
}

variable "time_zone" {
  type = string
  description = "Time zone"
  default = "Europe/Berlin"
  
}
