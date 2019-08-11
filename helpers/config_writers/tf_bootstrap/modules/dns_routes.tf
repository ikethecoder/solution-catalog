
# Create a new domain
resource "digitalocean_domain" "default" {
  name       = "${var.domain_name}"

}

# Keep ttl short until we are happy with the ecosystem we are building

resource "digitalocean_record" "a-record" {
  domain = "${digitalocean_domain.default.name}"
  type   = "A"
  name   = "@"
  value  = "${digitalocean_droplet.base.ipv4_address}"
  ttl    = "30"
}

resource "digitalocean_record" "a-vault" {
  domain = "${digitalocean_domain.default.name}"
  type   = "A"
  name   = "vault"
  value  = "${digitalocean_droplet.base.ipv4_address_private}"
  ttl    = "30"
}

resource "digitalocean_record" "wildcard" {
  domain = "${digitalocean_domain.default.name}"
  type   = "CNAME"
  name   = "*.ops"
  value  = "${digitalocean_domain.default.name}."
  ttl    = "30"
}

