resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "terraform-tiller"
    namespace = "kube-system"
  }

  #automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller-cluster-role"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind = "ServiceAccount"
    name = "${kubernetes_service_account.tiller.metadata.0.name}"

    api_group = ""
    namespace = "kube-system"
  }
}

provider "helm" {
    kubernetes {
      host = "${digitalocean_kubernetes_cluster.cluster.endpoint}"

      client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.cluster.kube_config.0.client_certificate)}"
      client_key             = "${base64decode(digitalocean_kubernetes_cluster.cluster.kube_config.0.client_key)}"
      cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)}"
    }

    service_account = "${kubernetes_service_account.tiller.metadata.0.name}"
    namespace       = "${kubernetes_service_account.tiller.metadata.0.namespace}"
    tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.12.3"
    install_tiller  = "true"
}

resource "null_resource" "helm-hack" {
  provisioner "local-exec" {
    command = "helm init --client-only"
  }
}
