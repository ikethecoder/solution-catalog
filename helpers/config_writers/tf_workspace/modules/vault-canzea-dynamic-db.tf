
resource "random_string" "secretToken" {
  length = 16
  special = true
  override_special = "/@\" "
}

data "vault_generic_secret" "mongodb" {
  path = "secret/tenants/01/services/mongodb"
}

data "vault_generic_secret" "rabbitmq" {
  path = "secret/tenants/01/services/rabbitmq"
}

resource "vault_generic_secret" "dynamic-db" {
  path = "secret/tenants/01/services/dynamic-db"

  data_json = <<EOT
    {
        "apiToken": "${random_string.secretToken.result}",
        "security": {
            "originWhitelist": "*",
            "accessRule": "",
            "jwtSigningKey": "${random_string.secretToken.result}"
        },
        "rabbitmq": {
            "addresses" : "console-app-rabbitmq.cicd.svc.cluster.local",
            "username": "${data.vault_generic_secret.rabbitmq.data["username"]}",
            "password": "${data.vault_generic_secret.rabbitmq.data["password"]}"
        },
        "mongodb": {
            "host" : "canzea-mongodb.apps.svc.cluster.local",
            "port" : 27017,
            "database" : "canzea_db",
            "username": "${data.vault_generic_secret.mongodb.data["username"]}",
            "password": "${data.vault_generic_secret.mongodb.data["password"]}"
        }
    }
  EOT
}
