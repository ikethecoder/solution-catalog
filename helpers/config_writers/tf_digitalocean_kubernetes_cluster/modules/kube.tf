resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = "${var.cluster_id}"
  region  = "${var.region}"
  version = "${var.kube_version}"
  tags    = ["all"]

  node_pool {
    name       = "default-pool"
    size       = "${var.node_pool_size}"
    node_count = "${var.node_pool_count}"
  }
}

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
  filename    = "kube_config"
}
