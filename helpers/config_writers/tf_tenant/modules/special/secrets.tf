resource "vault_generic_secret" "namedotcom" {
  path = "secret/tenants/${var.tenant_id}/providers/namedotcom"

  data_json = <<EOT
    {
        "username": "${var.namedotcom["username"]}",
        "key": "${var.namedotcom["key"]}"
    }
  EOT
}

resource "vault_generic_secret" "stripe" {
  path = "secret/tenants/${var.tenant_id}/providers/stripe"

  data_json = <<EOT
    {
        "private_key": "${var.stripe["private_key"]}",
        "public_key": "${var.stripe["public_key"]}"
    }
  EOT
}

resource "vault_generic_secret" "do_s3" {
  path = "secret/tenants/${var.tenant_id}/providers/do_s3"

  data_json = <<EOT
    {
        "access_key": "${var.s3["access_key"]}",
        "secret_key": "${var.s3["secret_key"]}",
        "bucket": "${var.es_id}-bucket"
    }
  EOT
}