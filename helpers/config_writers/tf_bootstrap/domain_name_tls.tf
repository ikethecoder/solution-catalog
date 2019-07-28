variable domain_name {}





provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = "${var.email}"
}

resource "acme_certificate" "certificate" {
  account_key_pem           = "${acme_registration.reg.account_key_pem}"
  common_name               = "*.${digitalocean_domain.default.name}"
  subject_alternative_names = [
      "${digitalocean_domain.default.name}",
#      "*.cloud.${digitalocean_domain.default.name}",
      "*.ops.${digitalocean_domain.default.name}"
  ]

  dns_challenge {
    provider = "digitalocean"

    config = {
        DO_AUTH_TOKEN = "${var.do["token"]}"
    }
  }

  depends_on = [
    "digitalocean_record.a-record",
    "digitalocean_record.wildcard",
    "digitalocean_droplet.{{instance}}",
    "digitalocean_firewall.min"
  ]
}

output "host" {
    value = "${digitalocean_domain.default.name}"
}

output "acme_account_key" {
  value = "${acme_registration.reg.account_key_pem}"
}
