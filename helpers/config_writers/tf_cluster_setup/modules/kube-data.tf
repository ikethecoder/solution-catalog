data "digitalocean_droplet" "cluster-node" {
  name = "${var.node_cluster}"

}
