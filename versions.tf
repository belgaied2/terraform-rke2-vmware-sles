terraform {
  required_version = ">= 0.12"
  required_providers {
    vsphere = {
      source = "registry.opentofu.org/hashicorp/vsphere"
      version = "2.10.0"
    }
    helm = {
      source = "registry.opentofu.org/hashicorp/helm"
      version = "2.16.1"
    }
    rancher2 = {
      source = "registry.opentofu.org/rancher/rancher2"
      version = "6.0.0"
    }
  }

  backend "s3" {
    bucket = "airbus-tf-state"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}