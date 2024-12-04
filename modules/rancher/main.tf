locals {
  # TODO: Implement computation for the need to install cert-manager
  install_certmanager = false
}

resource "null_resource" "cert_manager_crd" {
  count = local.install_certmanager ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/${var.certmanager_version}/cert-manager.crds.yaml --kubeconfig kube_config_cluster.yml"
  }

   provisioner "local-exec" {
    command = "kubectl create namespace cert-manager --kubeconfig kube_config_cluster.yml"
  }
}

resource "kubernetes_namespace" "cattle_system" {
  metadata {
    name = "cattle-system"
  } 
}


resource "helm_release" "cert_manager" {
  count = local.install_certmanager ? 1 : 0

  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.certmanager_version
  namespace  = "cert-manager"
  depends_on = [null_resource.cert_manager_crd]
}

resource "kubernetes_secret" "rancher_cert" {
  count = local.install_certmanager ? 0 : 1
  metadata {
    name      = "tls-rancher-ingress"
    namespace = kubernetes_namespace.cattle_system.metadata[0].name
  }

  data = {
    "tls.crt" = file("${path.module}/certs/cert.pem")
    "tls.key" = file("${path.module}/certs/key.pem")
  } 
}

resource "kubernetes_secret" "rancher_ca" {
  count = local.install_certmanager ? 0 : 1
  metadata {
    name      = "tls-ca"
    namespace = kubernetes_namespace.cattle_system.metadata[0].name
  }

  data = {
    "cacerts.pem" = file("${path.module}/certs/cacerts.pem")
  } 
}



resource "helm_release" "rancher_release" {
  name       = "rancher"
  chart      = "rancher"
  repository = "https://releases.rancher.com/server-charts/stable"
  namespace  = kubernetes_namespace.cattle_system.metadata[0].name
  version    = "2.9.3"
  set {
    name  = "hostname"
    value = var.url
  }
  dynamic "set" {
    for_each = local.install_certmanager ? [] : [1]
    content {
      name  = "privateCA"
      value = "true"
    }
  }

  dynamic "set" {
    for_each = local.install_certmanager ? [] : [1]
    content {
      name  = "ingress.tls.source"
      value = "secret"
    }
  }

  depends_on = [helm_release.cert_manager,null_resource.cert_manager_crd, kubernetes_secret.rancher_cert, kubernetes_secret.rancher_ca]
}

#resource "helm_release" "rancher_release" {
#  name       = "rancher"
#  repository = "https://releases.rancher.com/server-charts/stable"
#  chart      = "rancher"
#  namespace  = "cattle-system"
#    set {
#    name  = "bootstrapPassword"
#    value = var.rancher_bootstrap_password
#  }
#    set {
#    name  = "hostname"
#    value = var.url
#  }
#
#  depends_on = [helm_release.cert-manager,null_resource.cert-manager-crd]
#}




resource "rancher2_bootstrap" "admin" {
  provider         = rancher2.bootstrap
  initial_password = var.rancher_install_password
  password         = var.rancher_password
  telemetry        = false
  #depends_on       = [helm_release.rancher_release]
}



# Create a new rancher2 Auth Config ActiveDirectory
resource "rancher2_auth_config_activedirectory" "activedirectory" {
  provider = rancher2.admin
  servers = var.ad_server
  service_account_username = var.ad_username_browse
  service_account_password = var.ad_password_browse
  user_search_base = var.ad_searchbase
  port = var.ad_port
  test_username = var.ad_username_admin
  test_password = var.ad_password_admin
}








