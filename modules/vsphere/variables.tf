variable "node_count"{
    type = number
    description = "Number of nodes to provision"
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

variable "disk_size" {
    type = string
    description = "Disk size"
    default = ""
  
}

variable "node_names" {
    type = list(string)
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

variable "dns_server" {
    type = string
    description = "Ips of the nodes"
}

variable "time_zone" {
  type = string
  description = "Time zone"
  default = "Europe/Berlin"
  
}

variable "list_userdata_b64" {
  type = list(string)
  description = "Userdata"
  
}

variable "ad_domain" {
  type = string
  description = "Active Directory Domain"
  default = ""
  
}

variable "vm_ip_list" {
  type = list(string)
  description = "List of ips for the VMs"
}

variable "network_mask" {
  type = string
  description = "Network mask"
  default = "23"
}

variable "network_gateway" { 
  type = string
  description = "Network gateway Ip address."
}
