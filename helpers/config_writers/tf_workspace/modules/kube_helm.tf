
provider "helm" {
    version = "1.2.1"
    kubernetes {
      load_config_file = false
      host = "${digitalocean_kubernetes_cluster.cluster.endpoint}"

      token = "${digitalocean_kubernetes_cluster.cluster.kube_config.0.token}"
      cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)}"
    }

#    service_account = "${kubernetes_service_account.tiller.metadata.0.name}"
#    namespace       = "${kubernetes_service_account.tiller.metadata.0.namespace}"
#    tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.12.3"
#    install_tiller  = "true"
}
