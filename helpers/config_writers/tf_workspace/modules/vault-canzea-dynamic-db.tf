
resource "random_string" "secretToken" {
  length = 16
  special = false
  override_special = "/@\" "
}

data "vault_generic_secret" "mongodb" {
  path = "secret/tenants/${var.tenant_id}/services/mongodb"
}

data "vault_generic_secret" "rabbitmq" {
  path = "secret/tenants/${var.tenant_id}/services/rabbitmq"
}

resource "vault_generic_secret" "dynamic-db" {
  path = "secret/tenants/${var.tenant_id}/services/dynamic-db"

  data_json = <<EOT
    {
        "apiToken": "${random_string.secretToken.result}",
        "security": {
            "originWhitelist": "*",
            "accessRule": "",
            "jwtSigningKey": "${random_string.secretToken.result}"
        },
        "rabbitmq": {
            "addresses" : "rabbitmq.apps.svc.cluster.local",
            "username": "${data.vault_generic_secret.rabbitmq.data["username"]}",
            "password": "${data.vault_generic_secret.rabbitmq.data["password"]}"
        },
        "mongodb": {
            "host" : "mongodb.apps.svc.cluster.local",
            "port" : 27017,
            "database" : "general",
            "username": "${data.vault_generic_secret.mongodb.data["username"]}",
            "password": "${data.vault_generic_secret.mongodb.data["password"]}"
        }
    }
  EOT
}
