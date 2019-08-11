

data "vault_generic_secret" "namedotcom" {
  path = "secret/tenants/${var.tenant_id}/providers/namedotcom"
}

data "vault_generic_secret" "stripe" {
  path = "secret/tenants/${var.tenant_id}/providers/stripe"
}

resource "vault_generic_secret" "saas-express" {
  path = "secret/tenants/${var.tenant_id}/services/saas-express"

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
        "namedotcom": {
            "username" : "${data.vault_generic_secret.namedotcom.data["username"]}",
            "key" : "${data.vault_generic_secret.namedotcom.data["key"]}",
            "minDomain" : 0,
            "maxDomain": 0
        },
        "rootFolder": "/tmp",
        "apiRootUrl": "http://localhost:2000",
        "defaultCatalogVersion": "v1.0.2",
        "defaultCatalogBranch": "develop",
        "externalUrl": "https://console-ui.${var.workspace}.ws.${var.domain_name}",
        "autoVerify": true,
        "rootEcosystemDomain": "canzea.cc",
        "cli": "canzea",
        "dynamicdb": {
          "url": "https://dynamic-db.${var.workspace}.ws.${var.domain_name}",
          "apiToken": "${random_string.secretToken.result}"
        },
        "stripe": {
          "key": "${data.vault_generic_secret.stripe.data["private_key"]}"
        }
    }
  EOT
}


