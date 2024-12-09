resource "null_resource" "wait_for_rke2_main" {
  provisioner "local-exec" {
  command = "while ! curl -k -u node:${var.rke2_token} -s -o /dev/null -w '%{http_code}' https://${var.main_ip}:9345/v1-rke2/readyz | grep -q 200; do echo 'Retrying...'; sleep 5; done && echo 'RKE2 is ready!'"
  }

}

resource "null_resource" "wait_for_rke2_nodes" {
  count = var.node_count -1
  provisioner "local-exec" {
  #var.nodes_ip[count.index]
  command = "while ! curl -k -u node:${var.rke2_token} -s -o /dev/null -w '%{http_code}' https://${var.nodes_ip[count.index]}:9345/v1-rke2/readyz | grep -q 200; do echo 'Retrying...'; sleep 5; done && echo 'RKE2 is ready!'"
  }
  depends_on = [ null_resource.wait_for_rke2_main ] 
}

resource "null_resource" "get_kubeconfig" {

  provisioner "local-exec" {
  command = "ssh -i ${var.ssh_private_key} -o StrictHostKeyChecking=no ${var.node_ssh_user}@${var.main_ip} 'sudo cat /etc/rancher/rke2/rke2.yaml' > kube_config_cluster.yml && chmod 0600 kube_config_cluster.yml"
  }

  provisioner "local-exec" {
  command = "sed -i 's|127.0.0.1|${var.url}|g' ${path.root}/kube_config_cluster.yml"
  }

  provisioner "local-exec" {
    when = destroy
    command = "rm -f ${path.root}/kube_config_cluster.yml"
  }
  depends_on = [ null_resource.wait_for_rke2_nodes ]
}