resource "vault_generic_secret" "rabbitmq" {
  path = "secret/tenants/${var.tenant_id}/${var.workspace}/services/rabbitmq"

  data_json = <<EOT
    {
        "username": "${random_string.rabbitmqSuperUser.result}",
        "password": "${random_string.rabbitmqSuperPassword.result}"
    }
  EOT
}
