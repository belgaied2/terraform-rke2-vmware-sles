locals {
  # TODO: Implement computation for the need to install cert-manager
  install_certmanager = false
}

resource "null_resource" "cert-manager-crd" {
  count = local.install_certmanager ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/${var.certmanager_version}/cert-manager.crds.yaml --kubeconfig kube_config_cluster.yml"
  }

   provisioner "local-exec" {
    command = "kubectl create namespace cert-manager --kubeconfig kube_config_cluster.yml"
  }
  
   provisioner "local-exec" {
    command = "kubectl create namespace cattle-system --kubeconfig kube_config_cluster.yml"
  }
}


resource "helm_release" "cert-manager" {
  count = local.install_certmanager ? 1 : 0

  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.certmanager_version
  namespace  = "cert-manager"
  depends_on = [null_resource.cert-manager-crd]
}

resource "helm_release" "rancher_release" {
  name       = "rancher"
  repository = "https://releases.rancher.com/server-charts/stable"
  chart      = "rancher"
  namespace  = "cattle-system"
    set {
    name  = "hostname"
    value = var.url
  }

  depends_on = [helm_release.cert-manager,null_resource.cert-manager-crd]
}
