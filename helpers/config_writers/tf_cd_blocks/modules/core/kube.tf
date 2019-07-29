
provider "kubernetes" {

  host = "${var.kube_host}"

  client_certificate     = "${var.kube_client_certificate}"
  client_key             = "${var.kube_client_key}"
  cluster_ca_certificate = "${var.kube_cluster_ca_certificate}"
}

data "digitalocean_droplet" "cluster-node" {
  name = "${var.node_cluster}"
}
