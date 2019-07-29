

provider "helm" {
    kubernetes {
        host = "${var.kube_host}"

        client_certificate     = "${var.kube_client_certificate}"
        client_key             = "${var.kube_client_key}"
        cluster_ca_certificate = "${var.kube_cluster_ca_certificate}"
    }

#    service_account = "${kubernetes_service_account.tiller.metadata.0.name}"
#    namespace       = "${kubernetes_service_account.tiller.metadata.0.namespace}"
#    tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.12.3"
#    install_tiller  = "true"
}

resource null_resource "helm_init" {
    provisioner local-exec {
        command = "echo nothing"
#        command = "helm init --client-only"
    }

#    depends_on = [
#        "kubernetes_service_account.tiller",
#        "kubernetes_cluster_role_binding.tiller"
#    ]
}
