
resource "vault_policy" "cicd-access-policy" {
  name = "cicd-access-policy"

  policy = <<EOT
    path "secret/tenants/${var.tenant_id}/services/*" {
        capabilities = ["read"]
    }
    path "secret/tenants/${var.tenant_id}/providers/*" {
        capabilities = ["read"]
    }
    path "secret/tenants/${var.tenant_id}/cluster" {
        capabilities = ["read"]
    }
  EOT
}

resource "vault_approle_auth_backend_role" "cicd-access" {
  role_name = "cicd-access-role"
  policies  = ["${vault_policy.cicd-access-policy.name}"]
  token_ttl = 30000
  token_max_ttl = 60000
}

resource "vault_approle_auth_backend_role_secret_id" "cicd-access" {
  role_name = "${vault_approle_auth_backend_role.cicd-access.role_name}"

  metadata = <<EOT
    {
    }
  EOT
}

