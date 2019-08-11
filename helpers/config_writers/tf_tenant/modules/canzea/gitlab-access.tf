
resource "canzea_resource" "gitlab-access" {
  path = "/gitlab/user_deploy_key"

  attributes = {
      title = "${var.domain_name} deploy key"
      key = "${var.gocd_public_key_openssh}"
  }

  depends_on = [
      "vault_generic_secret.gitlab"
  ]
}

resource "vault_generic_secret" "gitlab" {
  path = "secret/tenants/${var.tenant_id}/provider/gitlab"

  data_json = <<EOT
    {
      "personal_access_token": "${var.gitlab["password"]}",
      "url": "https://gitlab.com"
    }
  EOT
}

resource "canzea_resource" "gitlab-repo-webhook" {
  path = "/gitlab/webhook/ikethecoder%2Fcanzea-public"

  attributes = {
    url = "https://providergw.cloud.${var.domain_name}/gw/hooks/${var.tenant_id}/gitlab"
    secret = "${var.vault_token}"
  }

  depends_on = [
      "vault_generic_secret.gitlab"
  ]
}
