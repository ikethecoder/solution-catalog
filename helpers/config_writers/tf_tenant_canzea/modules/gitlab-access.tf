
resource "canzea_resource" "gitlab-access" {
  path = "/gitlab/user_deploy_key"

  attributes = {
      title = "${var.domain_name} deploy key"
      key = "${var.gocd_public_key_openssh}"
  }

  depends_on = [
      "vault_generic_secret.tenant-es1222-gitlab"
  ]
}

resource "vault_generic_secret" "tenant-es1222-gitlab" {
  path = "secret/tenants/01/provider/gitlab"

  data_json = <<EOT
    {
      "personal_access_token": "${var.gitlab["password"]}",
      "url": "https://gitlab.com"
    }
  EOT
}

/*

gitlab = {
    username  = "ikethecoder"
    password = "uBLvyh6DhsTxY-QLJmqj"
}
*/