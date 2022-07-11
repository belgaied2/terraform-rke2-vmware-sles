

resource "null_resource" "cert-manager-crd" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.1/cert-manager.crds.yaml --kubeconfig kube_config_cluster.yml"
  }

   provisioner "local-exec" {
    command = "kubectl create namespace cert-manager --kubeconfig kube_config_cluster.yml"
  }
  
   provisioner "local-exec" {
    command = "kubectl create namespace cattle-system --kubeconfig kube_config_cluster.yml"
  }
}


resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.5.1"
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
