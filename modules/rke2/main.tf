resource "null_resource" "get_kubeconfig" {

  provisioner "local-exec" {
  command = "ssh -i ${var.ssh_private_key} -o StrictHostKeyChecking=no ${var.node_ssh_user}@${var.main_ip} 'sudo cat /etc/rancher/rke2/rke2.yaml' > kube_config_cluster.yml"
  }

  provisioner "local-exec" {
  command = "sed -i 's|127.0.0.1|${var.url}|g' ${path.root}/kube_config_cluster.yml"
  }
}

resource "null_resource" "check_access" {


  provisioner "local-exec" {
  command = "kubectl --kubeconfig=${path.root}/kube_config_cluster.yml get nodes"
  }

  depends_on = [null_resource.get_kubeconfig]
}