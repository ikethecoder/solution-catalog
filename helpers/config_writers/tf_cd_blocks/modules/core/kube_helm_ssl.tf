provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "acme_certificate" "certificate" {
  account_key_pem           = "${var.acme_account_key}"
  common_name               = "cloud.${var.domain_name}"
  subject_alternative_names = [
      "*.cloud.${var.domain_name}"
  ]

  dns_challenge {
    provider = "digitalocean"

    config = {
        DO_AUTH_TOKEN = "${var.do_token}"
    }
  }
}


output domain_tls_certificate_pem {
    value = "${acme_certificate.certificate.certificate_pem}"
}

output domain_tls_issuer_pem {
    value = "${acme_certificate.certificate.issuer_pem}"
}

output domain_tls_private_key_pem {
    value = "${acme_certificate.certificate.private_key_pem}"
}

