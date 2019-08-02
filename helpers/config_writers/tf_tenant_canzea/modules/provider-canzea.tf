
provider "canzea" {
  uri                  = "https://providergw.cloud.${var.domain_name}/gw/resources/"
  debug                = true
  write_returns_object = true

  headers = {
      "x-vault-token" = "${vault_approle_auth_backend_login.login.client_token}"
      "x-tenant-id"   = "${var.tenant_id}"
      "content-type"  = "application/json"
  }
}

