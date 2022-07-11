# terraform-rke2-vmware-sles
Provisionning script to provisionn a high availability Racnher cluster with RKE2 on a VMWare infrastructure.

## Prerequisites 
- Terraform version >= 13
- kubectl



## How to 

Fetch the repository: 
```
git clone https://github.com/fultux/terraform-rke2-vmware-sles.git
```

Create a value file like the following exemple with values set to your needs: 


```
#vsphere
vsphere_user = ""
vsphere_password = ""
vsphere_server = ""
vsphere_dc = ""
vsphere_cluster = ""
vsphere_datastore = ""
vsphere_network = ""
vsphere_resource_pool = ""
vsphere_template = ""

#Nodes
node_name = ""
node_vcpu = 
node_memory = ""
ssh_key = ""
ssh_user = ""
node_count=3
ssh_private_key = "~/.ssh/id_rsa"
subnet_mask = "24"
network_gateway = "172.16.128.1"
dns_server = ""
main_ip = ""
nodes_ip = ["",""]
registration_key = "" #SLES Activation key

#Loadbalancer
lb_memory = "" #Amount of ram used for the loadbalancer
lb_vcpu =  #Number of vcpu for the loadbalancer
lb_name = ""
lb_ip = "" #Ip of the loadbalancer
url = "frugiano-rancher.fremont.rancherlabs.com" #DNS name for the loadbalancer that was set up on your systenm

#RKE2
rke2_token = ""
cni = ""
rke2_version = "v1.21.5+rke2r1"
```

Init 

```
terraform init
```


plan then apply : 

```
terraform plan --var-file=<name-of-value-file>
terraform apply --var-file=<name-of-value-file>
```

Removal 
```
terraform destroy --var-file=values.tfvars
```
