
resource "null_resource" "sleep_reboot" {
  provisioner "local-exec" {
    command = "sleep 120"
  }
}


resource rke_cluster "cluster" {
cluster_name = "rke_test"
  dynamic nodes {
    for_each = var.nodes_ip
    content {
        ssh_agent_auth  = true
        address = nodes.value
        user    = "rancher"
        role    = ["controlplane", "etcd","worker"]
        ssh_key = file(var.ssh_key_file)
    }
  }  
depends_on = [null_resource.sleep_reboot]
}


###############################################################################
# If you need kubeconfig.yml for using kubectl, please uncomment follows.
###############################################################################
resource "local_file" "kube_cluster_yaml" {
   filename = "${path.root}/kube_config_cluster.yml"
   content  = rke_cluster.cluster.kube_config_yaml
 }