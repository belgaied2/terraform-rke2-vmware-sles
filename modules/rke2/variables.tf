variable "node_ssh_user" {
    type = string
    description = "node username"
}


variable "ssh_private_key"{
    type = string
    description = "Location of the private key to connect to the host"
}


variable "url" {
    type = string
    description = "url to reach the loadbalancer (must have been setup on your host machine)"
}


variable "main_ip" {
    type = string
    description = "main server IP"
}


variable "nodes_ip" {
    type = list
    description = "main server IP"
}
