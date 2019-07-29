
output "source_ssh_ip" {
    value = "${data.digitalocean_droplet.cluster-node.ipv4_address}"
}