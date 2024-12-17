provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

provider "helm" {
  kubernetes {
    # config_path = "kube_config_cluster.yml"
    host = "https://${var.nodes_ip[0]}:6443"
    cluster_ca_certificate = base64decode(module.rke2.kubeconfig.clusters[0].cluster.certificate-authority-data)
    client_certificate = base64decode(module.rke2.kubeconfig.users[0].user.client-certificate-data)
    client_key = base64decode(module.rke2.kubeconfig.users[0].user.client-key-data)

  }

  # localhost registry with password protection
  registry {
    url = "oci://${var.hosted_registry}:${var.hosted_registry_port}"
    username = var.hosted_registry_username
    password = var.hosted_registry_password
  }
}

provider "kubernetes" {
  # config_path = "kube_config_cluster.yml"
  host = "https://${var.nodes_ip[0]}:6443"
  cluster_ca_certificate = base64decode(module.rke2.kubeconfig.clusters[0].cluster.certificate-authority-data)
  client_certificate = base64decode(module.rke2.kubeconfig.users[0].user.client-certificate-data)
  client_key = base64decode(module.rke2.kubeconfig.users[0].user.client-key-data)



}

provider "rancher2" {
  alias = "bootstrap"

  api_url   = "https://${var.url}"
  bootstrap = true
  insecure  = true
}

provider "rancher2" {
  alias = "admin"

  api_url   = module.rancher.rancher_url
  token_key = module.rancher.rancher_token
  insecure  = true
}




