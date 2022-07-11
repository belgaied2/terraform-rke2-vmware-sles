
resource "null_resource" "start_rke2_server" {
  #Run accross all clientnode systems, built previously via count perhaps
  connection {
      type = "ssh"
      user = var.node_ssh_user
      private_key = file(var.ssh_private_key)  
      host = var.main_ip
  }
  
  provisioner "remote-exec" {
    # Run service restart on each node in the clutser
    inline = [
      "sudo systemctl enable rke2-server.service",
      "sudo systemctl start rke2-server.service",
    ]
  }
}


resource "null_resource" "waiting_time" {
  provisioner "local-exec" {
  command = "sleep 30"
  }

  provisioner "local-exec" {
  command = "ssh -i ${var.ssh_private_key} -o StrictHostKeyChecking=no ${var.node_ssh_user}@${var.main_ip} 'sudo cat /etc/rancher/rke2/rke2.yaml' > kube_config_cluster.yml"
  }

  provisioner "local-exec" {
  command = "sed -i 's|127.0.0.1|${var.url}|g' ${path.root}/kube_config_cluster.yml"
  }
  depends_on = [null_resource.start_rke2_server]
}


resource "null_resource" "start_rke2_clients" {
  #count = var.node_count -1
 
  provisioner "local-exec" {
  command = <<EOT
  %{ for node in var.nodes_ip ~}
  ssh -i ${var.ssh_private_key} -o StrictHostKeyChecking=no ${var.node_ssh_user}@${node} 'sudo systemctl enable rke2-server && sudo systemctl start rke2-server'
  %{ endfor ~}
  EOT
  }
  depends_on = [null_resource.waiting_time]
}


resource "null_resource" "get_kubeconfig" {


  provisioner "local-exec" {
  command = "kubectl --kubeconfig=${path.root}/kube_config_cluster.yml get nodes"
  }

  depends_on = [null_resource.start_rke2_clients]
}