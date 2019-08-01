resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = "${var.es_id}-${var.workspace}-cluster"
  region  = "${var.region}"
  version = "${var.kube_version}"
  tags    = []

  node_pool {
    name       = "${var.es_id}-${var.workspace}-pool"
    size       = "${var.node_pool_size}"
    node_count = "${var.node_pool_count}"
  }
}
/*
resource "digitalocean_kubernetes_node_pool" "mon" {
  cluster_id = "${digitalocean_kubernetes_cluster.cluster.id}"

  name       = "mon-pool"
  size       = "s-4vcpu-8gb"
  node_count = 1
  tags       = ["monitoring"]
}

resource "digitalocean_kubernetes_node_pool" "data" {
  cluster_id = "${digitalocean_kubernetes_cluster.cluster.id}"

  name       = "data-pool"
  size       = "s-4vcpu-8gb"
  node_count = 1
  tags       = []
}
*/


provider "kubernetes" {
  host = "${digitalocean_kubernetes_cluster.cluster.endpoint}"

  client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.cluster.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(digitalocean_kubernetes_cluster.cluster.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)}"
}


data "digitalocean_droplet" "cluster-node" {
  name = "${digitalocean_kubernetes_cluster.cluster.node_pool.0.nodes.0.name}"

  depends_on = [
    "digitalocean_kubernetes_cluster.cluster"
  ]

}

resource "local_file" "kube_config" {
  content     = "${digitalocean_kubernetes_cluster.cluster.kube_config.0.raw_config}"
  filename    = "kube_config_${var.workspace}"
}
