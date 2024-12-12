variable "url" {
    type = string
    description = "url to reach the loadbalancer (must have been setup on your host machine)"
}

variable "certmanager_version" {
    type = string
    description = "cert-manager version"
    default = "v1.5.1"
  
}

variable "rancher_password" {
  type = string
  description = "Rancher password"

}

variable "rancher_bootstrap_password" {
  type = string
  description = "Rancher bootstrap password"
  
}

variable "ad_username_browse" {
    type = string
    description = "Active Directory username"

}

variable "ad_password_browse" {
    type = string
    description = "Active Directory password"
    default = ""

}

variable "ad_domain" {
  type = string
  description = "Active Directory domain"

}

variable "ad_port" {
  type = number
  description = "Active Directory connection port"
  default = 389

}


variable "ad_searchbase" {
    type = string
    description = "User search base DN"
}



variable "ad_username_admin" {
    type = string
    description = "Active Directory admin username"

}

variable "ad_password_admin" {
    type = string
    description = "Active Directory password for the admin user"
    

}

variable "app_git_repo_url" {
  type = string
  description = "Git repository URL for fleet"
  }

variable "app_git_path" {
  type = string
  description = "Repository subpath if needed"
  default = ""
}

variable "repo_branch" {
  type = string
  description = "Branch from where to pull the app"
  default = "main"
}

variable "app_name" {
  type = string
  description = "Application name"
}

variable "cluster_name" {
  type = string
  description = "Cluster name"
  
}