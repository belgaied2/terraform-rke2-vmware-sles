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

resource "vsphere_virtual_machine" "loadbalancer" {
  name   = "fr-lb"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus = var.lb_vcpu
  memory   = var.lb_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type
  firmware = "bios"

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  enable_disk_uuid = true
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "fr-lb"
        domain    = "test.internal"
      }
      network_interface {
        ipv4_address = var.lb_ip
        ipv4_netmask = var.subnet_mask
        
    } 
      ipv4_gateway = var.network_gateway   
  }
}

extra_config = {
    "guestinfo.userdata" = base64encode(templatefile("${path.module}/templates/cloud_init.tftpl", {
      lb_ssh_user = var.lb_ssh_user
      lb_ssh_key = var.lb_ssh_key
      node_name = var.lb_name
      nodes_ip = var.nodes_ip
      main_ip  = var.main_ip
    }))
    "guestinfo.userdata.encoding" = "base64"
  }
}
  


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

resource "vsphere_virtual_machine" "loadbalancer" {
  name   = var.lb_name
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus = var.lb_vcpu
  memory   = var.lb_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type
  firmware = "bios"

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  enable_disk_uuid = true
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "fr-lb"
        domain    = "test.internal"
      }
      network_interface {
        ipv4_address = var.lb_ip
        ipv4_netmask = var.subnet_mask
        
    } 
      ipv4_gateway = var.network_gateway   
  }
}

extra_config = {
    "guestinfo.userdata" = base64encode(templatefile("${path.module}/templates/cloud_init.tftpl", {
      lb_ssh_user = var.lb_ssh_user
      lb_ssh_key = var.lb_ssh_key
      node_name = var.lb_name
      main_ip = vsphere_virtual_machine.main.*.default_ip_address
      nodes_ip  = vsphere_virtual_machine.nodes.*.default_ip_address
    }))
    "guestinfo.userdata.encoding" = "base64"




  }
}
  