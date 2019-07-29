provider "helm" {
    kubernetes {
        host = "${var.kube_host}"

        client_certificate     = "${var.kube_client_certificate}"
        client_key             = "${var.kube_client_key}"
        cluster_ca_certificate = "${var.kube_cluster_ca_certificate}"
    }
}
/*
resource "helm_repository" "private" {
    name = "private_${uuid()}"
    url  = "https://helm.ops.${var.domain_name}/charts"
    password = "${uuid()}"
}
*/