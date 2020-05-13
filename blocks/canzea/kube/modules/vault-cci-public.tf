resource "vault_generic_secret" "cci-public" {
  path = "secret/tenants/${var.tenant_id}/${var.workspace}/services/cci-public"

  data_json = <<EOT
    {
        "consoleUrl": "https://console.${var.workspace}.ws.${var.domain_name}"
    }
  EOT
}
