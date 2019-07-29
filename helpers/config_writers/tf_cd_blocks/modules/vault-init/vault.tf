data "http" "root_token" {
  url = "https://helm.ops.${var.domain_name}/temp/${var.one_time_token_retrieval}.txt"

  request_headers {
    "Accept" = "text/plain"
    "_WAIT_HACK" = "${var.module_depends_on}"
  }

}

provider "vault" {
  token = "${data.http.root_token.body}"
  address = "https://vault.ops.${var.domain_name}"
}

resource "vault_generic_secret" "example" {
  path = "secret/example"

  data_json = <<EOT
    {
      "foo":   "bar",
      "pizza": "cheese"
    }
  EOT
}

resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_approle_auth_backend_role" "example" {
  backend   = "${vault_auth_backend.approle.path}"
  role_name = "test-role"
  policies  = ["default", "dev", "prod","all"]
  token_ttl = 300
  token_max_ttl = 600
}

resource "vault_approle_auth_backend_role_secret_id" "id" {
  backend   = "${vault_auth_backend.approle.path}"
  role_name = "${vault_approle_auth_backend_role.example.role_name}"

  metadata = <<EOT
    {
      "hello": "world"
    }
  EOT
}

# Returns: client_token and 
resource "vault_approle_auth_backend_login" "login" {
  backend   = "${vault_auth_backend.approle.path}"
  role_id   = "${vault_approle_auth_backend_role.example.role_id}"
  secret_id = "${vault_approle_auth_backend_role_secret_id.id.secret_id}"
}

output "temp_token" {
  value = "${vault_approle_auth_backend_login.login.client_token}"
}