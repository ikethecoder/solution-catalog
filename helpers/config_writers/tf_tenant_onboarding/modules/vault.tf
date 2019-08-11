resource "vault_policy" "tenant" {
  name = "tenant-${var.tenant}"

  policy = <<EOT
    path "secret/tenants/${var.tenant}/*" {
    capabilities = ["create", "read", "update", "delete", "list"]
    }
  EOT
}

resource "vault_approle_auth_backend_role" "tenant" {
  role_name = "tenant-${var.tenant}-role"
  policies  = ["${vault_policy.tenant.name}"]
  token_ttl = 86400 /* 24 hours / 30 mins = 1800 */
  token_max_ttl = 172800
}

resource "vault_approle_auth_backend_role_secret_id" "tenant" {
  role_name = "${vault_approle_auth_backend_role.tenant.role_name}"

  metadata = <<EOT
    {
      "tenant_id": "${var.tenant}"
    }
  EOT
}
