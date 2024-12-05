provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

provider "helm" {
  kubernetes {
    config_path = "kube_config_cluster.yml"
  }
}

provider "kubernetes" {
  config_path = "kube_config_cluster.yml"
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




