

resource "vault_generic_secret" "job-manager" {
  path = "secret/tenants/${var.tenant_id}/services/job-manager"

  data_json = <<EOT
    {
        "apiToken": "${random_string.secretToken.result}",
        "security": {
            "originWhitelist": "*",
            "accessRule": "",
            "jwtSigningKey": "${random_string.secretToken.result}"
        },
        "rabbitmq": {
            "addresses" : "rabbitmq.cicd.svc.cluster.local",
            "username": "${data.vault_generic_secret.rabbitmq.data["username"]}",
            "password": "${data.vault_generic_secret.rabbitmq.data["password"]}"
        },
        "apiRootUrl": "http://localhost:2000",
        "defaultCatalogVersion": "v1.0.2",
        "defaultCatalogBranch": "develop",
        "externalUrl": "https://console-ui.${var.workspace}.ws.${var.domain_name}",
        "autoVerify": true,
        "rootEcosystemDomain": "canzea.cc",
        "cli": "canzea",
        "terraformCommand": "_terraform",
        "dynamicdb": {
          "url": "https://dynamic-db.${var.workspace}.ws.${var.domain_name}",
          "apiToken": "${random_string.secretToken.result}"
        }
    }
  EOT
}


