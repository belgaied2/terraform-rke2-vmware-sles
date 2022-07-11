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





resource "vsphere_virtual_machine" "main" {
  name             = "${var.node_name}-1"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus = var.node_vcpu
  memory   = var.node_memory
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
}


  extra_config = {

    "guestinfo.metadata" = base64encode(templatefile("${path.module}/templates/network_config.tftpl", {
      node_ip = var.main_ip
      network_gateway = var.network_gateway
      dns_server = var.dns_server
      node_name = "${var.node_name}-1"
    }))
    "guestinfo.metadata.encoding" = "base64"

    "guestinfo.userdata" = base64encode(templatefile("${path.module}/templates/cloud_init_main.cfg", {
      node_ssh_user = var.node_ssh_user,
      node_ssh_key = var.node_ssh_key
      node_name = "${var.node_name}-1"
      rke2_token = var.rke2_token
      cni = var.cni
      url = var.url
      lb_ip = var.lb_ip
    }))
    "guestinfo.userdata.encoding" = "base64"
  }

   provisioner "remote-exec" {
    inline = [
      "sudo curl -sfL https://get.rke2.io | sudo INSTALL_RKE2_VERSION='${var.rke2_version}' sh -",
    ]
    connection {
      type = "ssh"
      user = var.node_ssh_user
      private_key = file(var.ssh_private_key)  
      host = self.default_ip_address
    }
  }
}


resource "vsphere_virtual_machine" "nodes" {
  count = var.node_count -1
  name   = "${var.node_name}-${count.index +2}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus = var.node_vcpu
  memory   = var.node_memory
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

}

  extra_config = {
    "guestinfo.metadata" = base64encode(templatefile("${path.module}/templates/network_config.tftpl", {
      node_ip = element(var.nodes_ip,count.index +1)
      network_gateway = var.network_gateway
      dns_server = var.dns_server
      node_name = "${var.node_name}-${count.index +2}"

    }))
    "guestinfo.metadata.encoding" = "base64"
    
    "guestinfo.userdata" = base64encode(templatefile("${path.module}/templates/cloud_init_node.cfg", {
      node_ssh_user = var.node_ssh_user
      node_ssh_key = var.node_ssh_key
      node_name = "${var.node_name}-${count.index +2}"
      rke2_token = var.rke2_token
      cni = var.cni
      url = var.url
      lb_ip = var.lb_ip
    }))
    "guestinfo.userdata.encoding" = "base64"
  } 



   provisioner "remote-exec" {
    inline = [
      "sudo curl -sfL https://get.rke2.io | sudo INSTALL_RKE2_VERSION='${var.rke2_version}' sh -",
    ]
    connection {
      type = "ssh"
      user = var.node_ssh_user
      private_key = file(var.ssh_private_key)  
      host = self.default_ip_address
    }
  }
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

}

extra_config = {


    "guestinfo.metadata" = base64encode(templatefile("${path.module}/templates/network_config.tftpl", {
      node_ip = var.lb_ip
      network_gateway = var.network_gateway
      dns_server = var.dns_server
      node_name = var.lb_name

    }))
    "guestinfo.metadata.encoding" = "base64"

    "guestinfo.userdata" = base64encode(templatefile("${path.module}/templates/cloud_init.tftpl", {
      lb_ssh_user = var.lb_ssh_user
      lb_ssh_key = var.lb_ssh_key
      node_name = var.lb_name
	    main_ip = vsphere_virtual_machine.main.*.default_ip_address
      nodes_ip  = vsphere_virtual_machine.nodes.*.default_ip_address
      registration_key = var.registration_key
      
    }))
    "guestinfo.userdata.encoding" = "base64"



  }
}

