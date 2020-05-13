resource "vault_generic_secret" "console-ui" {
  path = "secret/tenants/${var.tenant_id}/${var.workspace}/services/console-ui"

  data_json = <<EOT
    {
        "apiRootUrl": "https://saas-express.${var.workspace}.ws.${var.domain_name}",
        "staticUrl": "https://${var.es_id}-bucket.sfo2.cdn.digitaloceanspaces.com/${var.tenant_id}/console-ui.${var.workspace}.ws",
        "homePage": "https://about.${var.workspace}.ws.${var.domain_name}",
        "dynamicdbUrl": "https://dynamic-db.${var.workspace}.ws.${var.domain_name}",
        "stripe": {
          "key": "${data.vault_generic_secret.stripe.data["public_key"]}"
        }
    }
  EOT
}
