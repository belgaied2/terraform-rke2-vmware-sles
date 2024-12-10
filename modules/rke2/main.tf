module "rancher_virtual_machines" {
  source = "../vsphere"

  vsphere_user = var.vsphere_user
	vsphere_password = var.vsphere_password
	vsphere_server = var.vsphere_server
	vsphere_cluster = var.vsphere_cluster
	vsphere_dc = var.vsphere_dc
	vsphere_datastore = var.vsphere_datastore
	vsphere_network = var.vsphere_network
	vsphere_resource_pool = var.vsphere_resource_pool
	vsphere_template = var.vsphere_template
	node_names = [for i in range(var.node_count) : "${var.node_name_prefix}${i +1}"]
	node_vcpu = var.node_vcpu
	node_memory = var.node_memory
	node_count = var.node_count
	network_gateway = var.network_gateway
	dns_server = var.dns_server
  ad_domain = var.ad_domain
  vm_ip_list = var.rancher_ip_list
  # Building the userdata array 
  list_userdata_b64 = [ for i in range(var.node_count) :

  base64encode(templatefile("${path.module}/templates/${i == 0 ? "cloud_init_first.cfg" : "cloud_init_join.cfg"}", {
      rke2_version = var.rke2_version,
      node_ssh_password = var.node_ssh_password,
      node_ssh_user = var.node_ssh_user,
      node_ssh_key = var.node_ssh_key
      node_name = "${var.node_name_prefix}${i + 1}"
      rke2_token = var.rke2_token
      cni = var.cni
      url = var.url
      ad_domain = var.ad_domain
      ad_username = var.ad_username
      ad_password = var.ad_password
      ad_group = var.ad_group
      init_node_ip = var.rancher_ip_list[0]
    }))
  ]
}

resource "null_resource" "wait_for_rke2_main" {
  provisioner "local-exec" {
  command = "while ! curl -k -u node:${var.rke2_token} -s -o /dev/null -w '%{http_code}' https://${var.main_ip}:9345/v1-rke2/readyz | grep -q 200; do echo 'Retrying...'; sleep 5; done && echo 'RKE2 is ready!'"
  }

}

resource "null_resource" "wait_for_rke2_nodes" {
  count = var.node_count -1
  provisioner "local-exec" {
  #var.nodes_ip[count.index]
  command = "while ! curl -k -u node:${var.rke2_token} -s -o /dev/null -w '%{http_code}' https://${var.rancher_ip_list[count.index]}:9345/v1-rke2/readyz | grep -q 200; do echo 'Retrying...'; sleep 5; done && echo 'RKE2 is ready!'"
  }
  depends_on = [ null_resource.wait_for_rke2_main ] 
}


data "remote_file" "get_kubeconfig" {
  conn {
    host = var.rancher_ip_list[0]
    port = 22
    user= var.node_ssh_user
    # password = var.node_ssh_password
    private_key_path = "/home/mohamed/.ssh/id_rsa"
    # private_key_path = var.ssh_private_key
    sudo = true
  }
  path = "/etc/rancher/rke2/rke2.yaml"

  depends_on = [null_resource.wait_for_rke2_nodes]
}

output "kubeconfig" {
  value = yamldecode(data.remote_file.get_kubeconfig.content) 
}

resource "time_sleep" "wait_for_kubeconfig" {
  depends_on = [data.remote_file.get_kubeconfig]
  create_duration = "1m"
  
}

