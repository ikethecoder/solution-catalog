
provider "canzea" {
  uri                  = "https://providergw.cloud.${var.domain_name}/gw/resources/"
  debug                = true
  write_returns_object = true

  headers = {
      "x-vault-token" = "${var.vault_token}"
      "x-tenant-id"   = "${var.tenant_id}"
      "content-type"  = "application/json"
  }
}

