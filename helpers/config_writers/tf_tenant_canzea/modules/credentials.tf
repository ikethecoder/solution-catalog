data "http" "root_token" {
  url = "https://helm.ops.${var.domain_name}/temp/${var.one_time_token_retrieval}.txt"

  request_headers {
    "Accept" = "text/plain"
  }

}

provider "vault" {
  token = "${data.http.root_token.body}"
  address = "https://vault.ops.${var.domain_name}"
}

resource "vault_policy" "example" {
  name = "tenant-x"

  policy = <<EOT
    path "secret/tenants/01/*" {
    capabilities = ["create", "read", "update", "delete", "list"]
    }
  EOT
}

resource "vault_approle_auth_backend_role" "example" {
  role_name = "onboard-role"
  policies  = ["${vault_policy.example.name}"]
  token_ttl = 30000
  token_max_ttl = 60000
}

resource "vault_approle_auth_backend_role_secret_id" "id" {
  role_name = "${vault_approle_auth_backend_role.example.role_name}"

  metadata = <<EOT
    {
      "tenant_id": "${var.es_id}"
    }
  EOT
}

# Returns: client_token and 
resource "vault_approle_auth_backend_login" "login" {
  role_id   = "${vault_approle_auth_backend_role.example.role_id}"
  secret_id = "${vault_approle_auth_backend_role_secret_id.id.secret_id}"
}

output "temp_token" {
  value = "${vault_approle_auth_backend_login.login.client_token}"
}

