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


variable "vsphere_user"{
  type = string
  description = "vsphere username"
}

variable "vsphere_password"{
  type = string
  description = "vsphere password"
}

variable "vsphere_server"{
  type = string
  description = "vsphere server"
}


variable "vsphere_dc" {
  type = string
  description = "Vsphere Datacenter"
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

variable "subnet_mask" {
  type = string
  description = "Hostname used for the loadbalancer"
  
}

variable "network_gateway" { 
  type = string
  description = "Network gateway Ip address."
}


variable "main_ip" {
    type = list
    description = "Ip of the main server"
}

variable "nodes_ip" {
    type = list
    description = "Ips of the nodes"
}


