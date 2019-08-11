
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

resource "vault_approle_auth_backend_login" "login" {
  role_id   = "${var.tenant_role_id}"
  secret_id = "${var.tenant_secret_id}"
}
