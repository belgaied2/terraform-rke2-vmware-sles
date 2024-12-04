resource "rancher2_cluster_v2" "custom_cluster_vsphere" {
  name = var.cluster_name
  kubernetes_version = var.k8s_version
  
}

resource "vsphere_virtual_machine" "downstream_cluster_node" {
  count = var.node_count

  name = "${var.node_prefix}${count.index}"

  resource_pool_id = var.vsphere_resource_pool != "" ? data.vsphere_resource_pool.pool[0].id : data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id = data.vsphere_datastore.datastore.id
  num_cpus = var.node_vcpu
  memory = var.node_memory
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
        host_name = "${var.node_prefix}${count.index}"
        domain = var.ad_domain
        time_zone = var.time_zone
      }
      network_interface {
        ipv4_address = cidrhost("${var.first_node_ip}/29", count.index)
        ipv4_netmask = "23"

      }
      ipv4_gateway = var.ipv4_gateway
      dns_server_list = [var.dns_server]
    }
  }

  extra_config = {
    
    "guestinfo.userdata" = base64encode(templatefile("${path.module}/templates/cloud_init_custom.cfg", {
      node_ssh_password = var.node_ssh_password
      node_ssh_user = var.node_ssh_user
      node_ssh_key = var.node_ssh_key
      node_name = "${var.node_prefix}${count.index}"
      ad_domain = var.ad_domain
      ad_username = var.ad_username
      ad_password = var.ad_password
      ad_group = var.ad_group
      node_command = local.node_command
    }))
    "guestinfo.userdata.encoding" = "base64"
  }


}