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

  count = var.node_count

  name             = var.node_names[count.index]
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
        host_name = var.node_names[count.index]
        domain = var.ad_domain
        time_zone = var.time_zone

      }
      network_interface {
        ipv4_address = var.vm_ip_list[count.index]
        ipv4_netmask = var.network_mask

      }
      ipv4_gateway = var.network_gateway
      dns_server_list = [ var.dns_server ]
    }
  }

  extra_config = {
    "guestinfo.userdata" = var.list_userdata_b64[count.index]
    "guestinfo.userdata.encoding" = "base64"
  }

  lifecycle {
    precondition {
      condition = length(var.list_userdata_b64) == var.node_count && length(var.vm_ip_list) == var.node_count
      error_message = "The number of both userdata and VM IP entries should be equal to the number of nodes"
    }  
  }
}