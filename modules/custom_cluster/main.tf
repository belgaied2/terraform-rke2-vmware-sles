locals {
  node_command = rancher2_cluster_v2.custom_cluster_vsphere.cluster_registration_token[0].insecure_node_command

}

resource "rancher2_cluster_v2" "custom_cluster_vsphere" {
  name = var.cluster_name
  kubernetes_version = var.k8s_version
    rke_config {
    additional_manifest = <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: kube-vip
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  name: system:kube-vip-role
rules:
  - apiGroups: [""]
    resources: ["services/status"]
    verbs: ["update"]
  - apiGroups: [""]
    resources: ["services", "endpoints"]
    verbs: ["list","get","watch", "update"]
  - apiGroups: [""]
    resources: ["nodes"]
    verbs: ["list","get","watch", "update", "patch"]
  - apiGroups: ["coordination.k8s.io"]
    resources: ["leases"]
    verbs: ["list", "get", "watch", "update", "create"]
  - apiGroups: ["discovery.k8s.io"]
    resources: ["endpointslices"]
    verbs: ["list","get","watch", "update"]
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  creationTimestamp: null
  name: kube-vip-ds
  namespace: kube-system
spec:
  selector:
    matchLabels:
      name: kube-vip-ds
  template:
    metadata:
      creationTimestamp: null
      labels:
        name: kube-vip-ds
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: node-role.kubernetes.io/master
                operator: Exists
            - matchExpressions:
              - key: node-role.kubernetes.io/control-plane
                operator: Exists
      containers:
      - args:
        - manager
        env:
        - name: vip_arp
          value: "true"
        - name: port
          value: "6443"
        - name: vip_interface
          value: "${var.interface_vip}"
        - name: vip_cidr
          value: "${var.vip_cidr}"
        - name: cp_enable
          value: "false"
        - name: cp_namespace
          value: kube-system
        - name: vip_ddns
          value: "false"
        - name: svc_enable
          value: "true"
        - name: vip_leaderelection
          value: "true"
        - name: vip_leaseduration
          value: "5"
        - name: vip_renewdeadline
          value: "3"
        - name: vip_retryperiod
          value: "1"
        - name: address
          value: ${var.vip_address}
        image: ghcr.io/kube-vip/kube-vip:v0.4.0
        imagePullPolicy: Always
        name: kube-vip
        resources: {}
        securityContext:
          capabilities:
            add:
            - NET_ADMIN
            - NET_RAW
            - SYS_TIME
      hostAliases:
        - hostnames:
            - kubernetes
          ip: 127.0.0.1
      hostNetwork: true
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      serviceAccount: kube-vip
      serviceAccountName: kube-vip
      terminationGracePeriodSeconds: 30
      tolerations:
        - effect: NoSchedule
          operator: Exists
        - effect: NoExecute
          operator: Exists
      volumes:
        - hostPath:
            path: /etc/rancher/rke2/rke2.yaml
          name: kubeconfig
EOF
    }
}

module "custom_cluster_virtual_machines" {
  source = "../vsphere"

  vsphere_user = var.vsphere_user
	vsphere_password = var.vsphere_password
	vsphere_server = var.vsphere_server
	vsphere_cluster = var.vsphere_cluster
	vsphere_dc = var.vsphere_dc
	vsphere_datastore = var.vsphere_datastore
	vsphere_network = var.vsphere_network
	vsphere_resource_pool = var.vsphere_resource_pool
	vsphere_template = var.vsphere_template
	node_names = [for i in range (var.node_count) : "${var.node_name_prefix}${i < 3 ? "-CP${i+1}" : "-WK${i - 2}"}"
]
	node_vcpu = var.node_vcpu
	node_memory = var.node_memory
	node_count = var.node_count
	network_gateway = var.network_gateway
	dns_server = var.dns_server
  ad_domain = var.ad_domain
  vm_ip_list = var.downstream_ip_list
  # Building the userdata array 
  list_userdata_b64 = [ for i in range(var.node_count) :

  base64encode(templatefile("${path.module}/templates/cloud_init_custom.cfg", {
      node_ssh_password = var.node_ssh_password,
      node_ssh_user = var.node_ssh_user,
      node_ssh_key = var.node_ssh_key
      node_name = "${var.node_name_prefix}${i < 3 ? "-CP${i+1}" : "-WK${i - 2}"}"
      ad_domain = var.ad_domain
      ad_username = var.ad_username
      ad_password = var.ad_password
      ad_group = var.ad_group
      node_command = "${local.node_command} --worker ${i < 3 ? " --controlplane --etcd" : ""}"
    }))
  ] 
}