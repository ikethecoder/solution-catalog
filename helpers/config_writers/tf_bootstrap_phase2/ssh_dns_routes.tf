resource "digitalocean_record" "a-source-ssh" {
  domain = "${digitalocean_domain.default.name}"
  type   = "A"
  name   = "source-ssh"
  value  = "${data.digitalocean_droplet.cluster-node.ipv4_address}"
  ttl    = "30"
}
