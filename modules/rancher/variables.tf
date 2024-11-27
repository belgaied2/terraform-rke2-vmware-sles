variable "url" {
    type = string
    description = "url to reach the loadbalancer (must have been setup on your host machine)"
}

variable "certmanager_version" {
    type = string
    description = "cert-manager version"
    default = "v1.5.1"
  
}

