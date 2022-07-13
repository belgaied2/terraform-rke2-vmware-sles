# terraform-rke2-vmware-sles
Scripts to provisionn a high availability Rancher cluster with RKE2 on a VMWare infrastructure.


## Prerequisites 
- Terraform version >= 13
- kubectl



## How to 

Fetch the repository: 
```
git clone https://github.com/fultux/terraform-rke2-vmware-sles.git
```
Create a value file using the following example with values set to your needs


```
#vsphere
vsphere_user = "" # Username to connect to vsphere.
vsphere_password = "" # Password for the vsphere user
vsphere_server = "" # Vsphere server address
vsphere_dc = "" # Vsphere Dataceter
vsphere_cluster = "" # Cluster name in the Vcenter
vsphere_datastore = "" # Datastore where the VMs will be stored.
vsphere_network = "" # Network zone where the VMs will be located.
vsphere_resource_pool = "" #resource pool
vsphere_template = "" # Name of the template that will be used to create the VMS. 

#Nodes
node_name = "" # Prefix that will be used for every VM in the cluster.
node_vcpu = # Number of VCPU
node_memory = "" # Amount of Memory in MB
ssh_key = "" # Full ssh public key that will be used to connect to the VM. 
ssh_user = "" # User to create for ssh and provsionning. Avoid using root for security reasons.  
node_count=3 # Number of nodes in the cluster. At least 3 for a HA cluster. Must be an odd number.
ssh_private_key = "~/.ssh/id_rsa" #Path of the private key. Obviously must be the one corresponding to the Public key you set up previously.
subnet_mask = "" #Netmask of the network
network_gateway = "" #IP of the Network gateway
dns_server = "" #IP of the DNS server

#In the case of a RKE2 cluster we have to provision a first node then add the other nodes to the cluster. You can't add every nodes to the cluster in  the same time. It's a sequential process. 

main_ip = "" #Ip for the first server to provition
nodes_ip = ["",""] #A list of ips for the other nodes in the cluster.
registration_key = "" #SLES Activation key

#Loadbalancer
lb_memory = "" #Amount of ram used for the loadbalancer
lb_vcpu =  #Number of vcpu for the loadbalancer
lb_name = "" #Name and hostname for the loadbalancer
lb_ip = "" #Ip of the loadbalancer
url = "" #DNS name for the loadbalancer that was set up on your systenm

#RKE2
rke2_token = "" # Token that will be used to add nodes to the cluster. 
cni = "" # Which CNI to be used can be calico, cilium or canal. 
rke2_version = "v1.21.5+rke2r1" # Version of the RKE2 engine. 
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
