
resource "vault_generic_secret" "mongodb" {
  path = "secret/tenants/01/services/mongodb"

  data_json = <<EOT
    {
        "username": "${random_string.mongoSuperUser.result}",
        "password": "${random_string.mongoSuperPassword.result}"
    }
  EOT
}
resource "vault_generic_secret" "rabbitmq" {
  path = "secret/tenants/01/services/rabbitmq"

  data_json = <<EOT
    {
        "username": "${random_string.rabbitmqSuperUser.result}",
        "password": "${random_string.rabbitmqSuperPassword.result}"
    }
  EOT
}
