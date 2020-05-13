

data "vault_generic_secret" "namedotcom" {
  path = "secret/tenants/${var.tenant_id}/${var.workspace}/providers/namedotcom"
}

data "vault_generic_secret" "stripe" {
  path = "secret/tenants/${var.tenant_id}/${var.workspace}/providers/stripe"
}

data "vault_generic_secret" "oauth_providers" {
  path = "secret/tenants/${var.tenant_id}/${var.workspace}/providers/oauth_providers"
}

resource "vault_generic_secret" "saas-express" {
  path = "secret/tenants/${var.tenant_id}/${var.workspace}/services/saas-express"

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
        "namedotcom": {
            "username" : "${data.vault_generic_secret.namedotcom.data["username"]}",
            "key" : "${data.vault_generic_secret.namedotcom.data["key"]}",
            "minDomain" : 0,
            "maxDomain": 0
        },
        "rootFolder": "/tmp",
        "apiRootUrl": "http://localhost:2000",
        "apiJobsRootUrl": "https://job-manager.${var.workspace}.ws.${var.domain_name}",
        "defaultCatalogVersion": "v1.0.2",
        "defaultCatalogBranch": "develop",
        "externalUrl": "https://console.${var.workspace}.ws.${var.domain_name}",
        "staticUrl": "https://${var.es_id}-bucket.sfo2.cdn.digitaloceanspaces.com/${var.tenant_id}/data-mining.cd.ws",
        "cdnUrl": "https://${var.es_id}-bucket.sfo2.cdn.digitaloceanspaces.com/${var.tenant_id}/console-ui.intg.ws",
        "autoVerify": true,
        "rootEcosystemDomain": "canzea.cc",
        "email": {
            "enabled": true,
            "url": "https://dynamic-db.${var.workspace}.ws.${var.domain_name}"
        },
        "cli": "canzea",
        "dynamicdb": {
          "url": "https://dynamic-db.${var.workspace}.ws.${var.domain_name}",
          "apiToken": "${random_string.secretToken.result}"
        },
        "stripe": {
          "key": "${data.vault_generic_secret.stripe.data["private_key"]}"
        },
        "oauth_providers": {
            "github" : ${data.vault_generic_secret.oauth_providers.data["github"]},
            "gitlab" : ${data.vault_generic_secret.oauth_providers.data["gitlab"]},
            "bitbucket" : ${data.vault_generic_secret.oauth_providers.data["bitbucket"]}
        }
    }
  EOT
}


