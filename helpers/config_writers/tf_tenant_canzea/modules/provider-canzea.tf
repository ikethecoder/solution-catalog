
provider "canzea" {
  uri                  = "https://providergw.cloud.${var.domain_name}/gw/resources/"
  debug                = true
  write_returns_object = true

  headers = {
      "X-Vault-Token" = "${vault_approle_auth_backend_login.login.client_token}"
      "Content-Type"  = "application/json"
  }
}

