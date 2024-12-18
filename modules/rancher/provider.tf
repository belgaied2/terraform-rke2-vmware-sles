terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
      version = "6.0.0"
    }
    kubectl = {
      source = "registry.opentofu.org/gavinbunney/kubectl"
      version = "1.18.0"
    }
  }
}