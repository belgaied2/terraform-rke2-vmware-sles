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

