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
  lifecycle {
    ignore_changes = [metadata]
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
  lifecycle {
    ignore_changes = [metadata]
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

  lifecycle {
    ignore_changes = [metadata]
  }
}


resource "helm_release" "rancher_release" {
  name       = "rancher"
  chart      = "rancher"
  repository = "oci://${var.hosted_registry}:${var.hosted_registry_port}/${var.rancher_helm_hosted_repository}"
  repository_username = var.hosted_registry_username
  repository_password = var.hosted_registry_password 
  namespace  = kubernetes_namespace.cattle_system.metadata[0].name
  version    = var.rancher_helm_tag
  set {
    name  = "hostname"
    value = var.url
  }
  set {
   name  = "bootstrapPassword"
   value = var.rancher_bootstrap_password
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

  depends_on = [helm_release.cert_manager,null_resource.cert_manager_crd, kubernetes_secret.rancher_cert, kubernetes_secret.rancher_ca, kubernetes_namespace.cattle_system]
}




resource "rancher2_bootstrap" "admin" {
  password         = var.rancher_password
  initial_password = var.rancher_bootstrap_password
  telemetry        = false
  depends_on       = [helm_release.rancher_release]
}



resource "kubernetes_manifest" "nginx_sample_app" {
  manifest = {
    apiVersion = "fleet.cattle.io/v1alpha1"
    kind = "GitRepo"

    metadata = {
      name = var.app_name
      namespace = "fleet-default"
    }

    spec = {
      branch = var.repo_branch
      paths = [var.app_git_path]
      repo = var.app_git_repo_url
      targets = [var.cluster_name]
    }

  }
}
