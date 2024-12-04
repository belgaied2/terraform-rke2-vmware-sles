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
  count = var.vsphere_resource_pool == "" ? 0 : 1
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
  name             = "${var.node_name}1"
  resource_pool_id = var.vsphere_resource_pool == "" ? data.vsphere_compute_cluster.cluster.resource_pool_id : data.vsphere_resource_pool.pool[0].id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus = var.node_vcpu
  memory   = var.node_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type
  firmware = "efi"
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  disk {
    label            = "disk0"
    size             = var.disk_size != "" ? var.disk_size : data.vsphere_virtual_machine.template.disks.0.size 
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  enable_disk_uuid = true
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "${var.node_name}1"
        domain = var.ad_domain
        time_zone = var.time_zone

      }
      network_interface {
        ipv4_address = var.main_ip
        ipv4_netmask = "23"

      }
      ipv4_gateway = var.network_gateway
      dns_server_list = [ var.dns_server ]
    }
  }


  extra_config = {

    # "guestinfo.metadata" = base64encode(templatefile("${path.module}/templates/network_config.tftpl", {
    #   node_ip = element(var.nodes_ip,0)
    #   network_gateway = var.network_gateway
    #   dns_server = var.dns_server
    #   node_name = "${var.node_name}0"

    # }))
    # "guestinfo.metadata.encoding" = "base64"

    "guestinfo.userdata" = base64encode(templatefile("${path.module}/templates/cloud_init_main.cfg", {
      rke2_version = var.rke2_version,
      node_ssh_password = var.node_ssh_password,
      node_ssh_user = var.node_ssh_user,
      node_ssh_key = var.node_ssh_key
      node_name = "${var.node_name}1"
      rke2_token = var.rke2_token
      cni = var.cni
      url = var.url
      ad_domain = var.ad_domain
      ad_username = var.ad_username
      ad_password = var.ad_password
      ad_group = var.ad_group
    }))
    "guestinfo.userdata.encoding" = "base64"
  }
}


resource "vsphere_virtual_machine" "nodes" {
  count = var.node_count -1
  name   = "${var.node_name}${count.index +2}"
  resource_pool_id = var.vsphere_resource_pool == "" ? data.vsphere_compute_cluster.cluster.resource_pool_id : data.vsphere_resource_pool.pool[0].id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus = var.node_vcpu
  memory   = var.node_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type
  firmware = "efi"

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = var.disk_size != "" ? var.disk_size : data.vsphere_virtual_machine.template.disks.0.size 
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  enable_disk_uuid = true
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "${var.node_name}${count.index+2}"
        domain = var.ad_domain
        time_zone = var.time_zone
      }
      network_interface {
        ipv4_address = var.nodes_ip[count.index]
        ipv4_netmask = "23"

      }
      ipv4_gateway = var.network_gateway
      dns_server_list = [var.dns_server]
    }
  }

  extra_config = {
    # "guestinfo.metadata" = base64encode(templatefile("${path.module}/templates/network_config.tftpl", {
    #   node_ip = element(var.nodes_ip,count.index +1)
    #   network_gateway = var.network_gateway
    #   dns_server = var.dns_server
    #   node_name = "${var.node_name}${count.index +2}"

    # }))
    # "guestinfo.metadata.encoding" = "base64"
    
    "guestinfo.userdata" = base64encode(templatefile("${path.module}/templates/cloud_init_node.cfg", {
      rke2_version = var.rke2_version,
      node_ssh_password = var.node_ssh_password
      node_ssh_user = var.node_ssh_user
      node_ssh_key = var.node_ssh_key
      node_name = "${var.node_name}${count.index +2}"
      init_node_ip = var.main_ip
      rke2_token = var.rke2_token
      cni = var.cni
      url = var.url
      ad_domain = var.ad_domain
      ad_username = var.ad_username
      ad_password = var.ad_password
      ad_group = var.ad_group
    }))
    "guestinfo.userdata.encoding" = "base64"
  } 
}  

