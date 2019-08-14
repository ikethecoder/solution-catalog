
resource "vault_generic_secret" "canzea-public" {
  path = "secret/tenants/${var.tenant_id}/services/canzea-public"

  data_json = <<EOT
    {
      "public_url": "https://public.${var.workspace}.ws.${var.domain_name}",
      "console_ui_url": "https://console-ui.${var.workspace}.ws.${var.domain_name}"
    }
  EOT
}


resource "vault_generic_secret" "console-ui" {
  path = "secret/tenants/${var.tenant_id}/services/console-ui"

  data_json = <<EOT
    {
        "apiRootUrl": "https://saas-express.${var.workspace}.ws.${var.domain_name}",
        "staticUrl": "https://${var.es_id}-bucket.sfo2.cdn.digitaloceanspaces.com/${var.tenant_id}/public.${var.workspace}.ws",
        "dynamicdbUrl": "https://dynamic-db.${var.workspace}.ws.${var.domain_name}",
        "stripe": {
          "key": "${data.vault_generic_secret.stripe.data["public_key"]}"
        }
    }
  EOT
}
