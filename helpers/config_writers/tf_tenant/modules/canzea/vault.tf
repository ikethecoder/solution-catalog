
resource "vault_generic_secret" "mongodb" {
  path = "secret/tenants/${var.tenant_id}/services/mongodb"

  data_json = <<EOT
    {
        "username": "${random_string.mongoSuperUser.result}",
        "password": "${random_string.mongoSuperPassword.result}"
    }
  EOT
}
resource "vault_generic_secret" "rabbitmq" {
  path = "secret/tenants/${var.tenant_id}/services/rabbitmq"

  data_json = <<EOT
    {
        "username": "${random_string.rabbitmqSuperUser.result}",
        "password": "${random_string.rabbitmqSuperPassword.result}"
    }
  EOT
}
