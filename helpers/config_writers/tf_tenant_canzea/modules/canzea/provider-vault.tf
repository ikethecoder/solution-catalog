
provider "vault" {
  token = "${var.vault_token}"
  address = "https://vault.ops.${var.domain_name}"
}
