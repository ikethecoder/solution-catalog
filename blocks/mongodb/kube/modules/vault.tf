resource "vault_generic_secret" "mongodb" {
  path = "secret/tenants/${var.tenant_id}/${var.workspace}/services/mongodb"

  data_json = <<EOT
    {
        "username": "${random_string.mongoSuperUser.result}",
        "password": "${random_string.mongoSuperPassword.result}"
    }
  EOT
}
