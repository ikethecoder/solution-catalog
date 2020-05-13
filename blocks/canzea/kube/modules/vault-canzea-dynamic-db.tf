
resource "random_string" "secretToken" {
  length = 16
  special = false
  override_special = "/@\" "
}

data "vault_generic_secret" "mongodb" {
  path = "secret/tenants/${var.tenant_id}/${var.workspace}/services/mongodb"
}

data "vault_generic_secret" "rabbitmq" {
  path = "secret/tenants/${var.tenant_id}/${var.workspace}/services/rabbitmq"
}

resource "vault_generic_secret" "dynamic-db" {
  path = "secret/tenants/${var.tenant_id}/${var.workspace}/services/dynamic-db"

  # dynamicdb added here because the lib-communication is deployed
  # here and it calls the dynamicdb API to get notification content datasets
  data_json = <<EOT
    {
        "apiToken": "${random_string.secretToken.result}",
        "url": "https://dynamic-db.${var.workspace}.ws.${var.domain_name}",
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
            "host" : "mongo-mongodb.apps.svc.cluster.local",
            "port" : 27017,
            "database" : "general",
            "username": "${data.vault_generic_secret.mongodb.data["username"]}",
            "password": "${data.vault_generic_secret.mongodb.data["password"]}"
        },
        "communications": {
            "from": "Canzea <contact@canzea.com>"
        }
    }
  EOT
}
