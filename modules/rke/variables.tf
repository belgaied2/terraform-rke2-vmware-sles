
variable node_count {
  type        = number
  default = 2
  description = "Number of nodes to be provisioned"
}


variable "nodes_ip" {
    type = list
    description = "List of workers nodes ip"
}

variable "ssh_key_file" {
    type = string
    description = "ssh key"
    default = "~/.ssh/id_rsa"
}