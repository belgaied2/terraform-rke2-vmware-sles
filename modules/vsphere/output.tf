output "main_ip" {
  description = "Ip address of the main node"
  value       = vsphere_virtual_machine.main.*.default_ip_address
}

output "nodes_ip" {
  description = "Ip addresses of the other nodes"
  value       = vsphere_virtual_machine.nodes.*.default_ip_address
}

