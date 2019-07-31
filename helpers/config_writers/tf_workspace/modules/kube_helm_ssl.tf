provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "acme_certificate" "certificate" {
  account_key_pem           = "${var.acme_account_key}"
  common_name               = "${var.workspace}.ws.${var.domain_name}"
  subject_alternative_names = [
      "*.${var.workspace}.ws.${var.domain_name}"
  ]

  dns_challenge {
    provider = "digitalocean"

    config = {
        DO_AUTH_TOKEN = "${var.do["token"]}"
    }
  }
}
