variable "cluster_description" {
  description = "Description of the cluster"
  type        = string
  
}

variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "node_count" {
  description = "Number of nodes to create"
  type        = number
}

variable "node_name_prefix" {
  description = "Prefix for the node names"
  type        = string
}

variable "node_vcpu" {
  description = "Number of vCPUs for the node"
  type        = number
}

variable "node_memory" {
  description = "Amount of memory for the node"
  type        = number
}

variable "disk_size" {
  description = "Size of the disk"
  type        = string
}

variable "vsphere_server" {
  description = "The vSphere server"
  type        = string
  
}

variable "vsphere_user" {
  description = "The vSphere user"
  type        = string
  
}

variable "vsphere_password" {
  description = "The vSphere password"
  type        = string
  
}

variable "vsphere_dc" {
  description = "The name of the vSphere datacenter"
  type        = string

}



variable "vsphere_datastore" {
  description = "The name of the vSphere datastore"
  type        = string

}



variable "vsphere_cluster" {
  description = "The name of the vSphere cluster"
  type        = string

}



variable "vsphere_resource_pool" {
  description = "The name of the vSphere resource pool"
  type        = string
  default     = ""

}



variable "vsphere_network" {
  description = "The name of the vSphere network"
  type        = string

}



variable "vsphere_template" {
  description = "The name of the vSphere template"
  type        = string

}

variable "ad_domain" {
  description = "Active Directory domain"
  type        = string

}

variable "time_zone" {
  description = "Time zone"
  type        = string
  
}

variable "first_node_ip" {
  description = "First node IP"
  type        = string
  
}

variable "ipv4_gateway" {
  description = "IPv4 gateway"
  type        = string 
}

variable "dns_server" {
  description = "DNS server"
  type        = string
}

variable "node_ssh_password" {
  description = "Password for the node SSH user"
  type        = string
  
}

variable "node_ssh_user" {
  description = "User for the node SSH user"
  type        = string
  
}

variable "node_ssh_key" {
  description = "SSH key for the node SSH user"
  type        = string
  
}

variable "ad_username" {
  description = "Active Directory username"
  type        = string
  
}

variable "ad_password" {
  description = "Active Directory password"
  type        = string
  
}

variable "ad_group" {
  description = "Active Directory group"
  type        = string
  
}

variable "k8s_version" {
  description = "Kubernetes version"
  type        = string
  
}

variable "network_gateway" {
  description = "Network gateway"
  type        = string
  
}

variable "rke2_version" {
  description = "RKE2 version"
  type        = string
  
}

variable "downstream_ip_list" {
  description = "List of downstream IPs"
  type        = list(string)
  
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