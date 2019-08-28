
resource "vault_generic_secret" "rpa-channel" {
  path = "secret/tenants/${var.tenant_id}/services/rpa-channel"

  data_json = <<EOT
    {
        "rabbitmq": {
            "host" : "rabbitmq.apps.svc.cluster.local",
            "username": "${data.vault_generic_secret.rabbitmq.data["username"]}",
            "password": "${data.vault_generic_secret.rabbitmq.data["password"]}"
        },
        "database": {
            "host" : "mongo-mongodb.apps.svc.cluster.local",
            "port" : 27017,
            "dbname" : "general",
            "username": "${data.vault_generic_secret.mongodb.data["username"]}",
            "password": "${data.vault_generic_secret.mongodb.data["password"]}"
        },
        "inputsource": "https://rpa-speak.${var.workspace}.ws.${var.domain_name}",
        "forward": "https://rpa-listen.${var.workspace}.ws.${var.domain_name}/tracks",
        "brain": {
            "url": "https://rpa-brain.${var.workspace}.ws.${var.domain_name}"
        }
    }
  EOT
}
