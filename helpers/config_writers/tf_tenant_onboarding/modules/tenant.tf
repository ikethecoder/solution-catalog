data "http" "root_token" {
  url = "https://helm.ops.${var.domain_name}/temp/${var.one_time_token_retrieval}.txt"

  request_headers {
    "Accept" = "text/plain"
  }

}

provider "vault" {
  token = "${data.http.root_token.body}"
  address = "https://vault.ops.${var.domain_name}"
}


# Add a pipeline_group
# Add a user
#
resource "vault_generic_secret" "tenant" {
  path = "secret/tenants/${var.tenant}/provider/gocd"

  data_json = <<EOT
    {
      "url":   "https://gocd.cloud.${var.domain_name}",
      "admin_username": "admin",
      "admin_password": "${var.gocd_admin_password}"
    }
  EOT
}

resource "vault_generic_secret" "tenant-do" {
  path = "secret/tenants/${var.tenant}/provider/do"

  data_json = <<EOT
    {
      "url":   "",
      "token": "${var.do_token}"
    }
  EOT
}

resource "vault_generic_secret" "tenant-gitea" {
  path = "secret/tenants/${var.tenant}/provider/gitea"

  data_json = <<EOT
    {
      "url":   "https://source.cloud.${var.domain_name}",
      "ssh_url": "git@source.cloud.${var.domain_name}",
      "admin_username": "scadmin",
      "admin_password": "${var.gitea_admin_password}"
    }
  EOT
}



/*
resource "gitlab_deploy_key" "canzea-pipelines" {
  project = "ikethecoder/canzea-pipelines"
  title   = "Deploy key for ${data.terraform_remote_state.core.domain_name}"
  key     = "${module.saas-providers.gocd_public_key_openssh}"
}

resource "gitlab_deploy_key" "canzea-public" {
  project = "ikethecoder/canzea-public"
  title   = "Deploy key for ${data.terraform_remote_state.core.domain_name}"
  key     = "${module.saas-providers.gocd_public_key_openssh}"
}


resource "gitlab_deploy_key" "dynamic-db" {
  project = "ikethecoder/dynamic-db"
  title   = "Deploy key for ${data.terraform_remote_state.core.domain_name}"
  key     = "${module.saas-providers.gocd_public_key_openssh}"
}

resource "gitlab_deploy_key" "console-app" {
  project = "ikethecoder/console-app"
  title   = "Deploy key for ${data.terraform_remote_state.core.domain_name}"
  key     = "${module.saas-providers.gocd_public_key_openssh}"
}
*/



# Configure the GitLab Provider
# provider "gitlab" {
#     token = "${var.gitlab_access_token}"
# }

# provider "gitlab" {
#     alias = "canzea"
#     token = "${var.gitlab_tenant_01["token"]}"
# }

/*

export TOKEN=s.0FBnX2AFkTD58QWV1uYUGsIs

 curl -v -X POST -H "X-Vault-Token: $TOKEN" -H "Content-Type: application/json" -d '{}' https://providergw.cloud.184768.xyz/gw/resources/auth_config

 curl -v -X POST -H "X-Vault-Token: s.h9t8cpVqEDSLgGApFgRsAbG3" -H "Content-Type: application/json" -d '{"name":"hugo","image":"registry.ops.184768.xyz/agents/static-hugo:latest"}' https://providergw.cloud.184768.xyz/gw/resources/gocd_elastic_profile
 curl -v -X POST -H "X-Vault-Token: s.h9t8cpVqEDSLgGApFgRsAbG3" -H "Content-Type: application/json" -d '{"name":"java8","image":"registry.ops.184768.xyz/agents/stack-java8:latest"}' https://providergw.cloud.184768.xyz/gw/resources/gocd_elastic_profile
 curl -v -X POST -H "X-Vault-Token: s.h9t8cpVqEDSLgGApFgRsAbG3" -H "Content-Type: application/json" -d '{"name":"nodejs8","image":"registry.ops.184768.xyz/agents/stack-nodejs8:latest"}' https://providergw.cloud.184768.xyz/gw/resources/gocd_elastic_profile
 curl -v -X POST -H "X-Vault-Token: s.h9t8cpVqEDSLgGApFgRsAbG3" -H "Content-Type: application/json" -d '{"name":"vault","image":"registry.ops.184768.xyz/agents/vault:latest"}' https://providergw.cloud.184768.xyz/gw/resources/gocd_elastic_profile
 curl -v -X POST -H "X-Vault-Token: s.h9t8cpVqEDSLgGApFgRsAbG3" -H "Content-Type: application/json" -d '{"name":"terraform","image":"registry.ops.184768.xyz/agents/terraform:latest"}' https://providergw.cloud.184768.xyz/gw/resources/gocd_elastic_profile
 curl -v -X POST -H "X-Vault-Token: s.h9t8cpVqEDSLgGApFgRsAbG3" -H "Content-Type: application/json" -d '{"name":"docker","privileged":true,"image":"gocd/gocd-agent-docker-dind:v19.1.0"}' https://providergw.cloud.184768.xyz/gw/resources/gocd_elastic_profile
 curl -v -X POST -H "X-Vault-Token: s.h9t8cpVqEDSLgGApFgRsAbG3" -H "Content-Type: application/json" -d '{"name":"helm211","image":"registry.ops.184768.xyz/agents/helm211:latest"}' https://providergw.cloud.184768.xyz/gw/resources/gocd_elastic_profile

 curl -v -X POST -H "X-Vault-Token: s.h9t8cpVqEDSLgGApFgRsAbG3" -H "Content-Type: application/json" -d '{"name":"core","url":"git@gitlab.com:ikethecoder/yamya-infra.git","branch":"develop"}' https://providergw.cloud.184768.xyz/gw/resources/gocd_config_repo
 curl -v -X POST -H "X-Vault-Token: s.h9t8cpVqEDSLgGApFgRsAbG3" -H "Content-Type: application/json" -d '{"name":"canzea","url":"git@gitlab.com:ikethecoder/canzea-pipelines.git","branch":"develop"}' https://providergw.cloud.184768.xyz/gw/resources/gocd_config_repo


 curl -v -X POST -H "X-Vault-Token: s.h9t8cpVqEDSLgGApFgRsAbG3" -H "Content-Type: application/json" -d '{"origin":"es0000-bucket.sfo2.digitaloceanspaces.com"}' https://providergw.cloud.184768.xyz/gw/resources/do_cdn

// CDN EDGE: https://es0000-bucket.sfo2.cdn.digitaloceanspaces.com

// environments:

dev
intg
prod

*/
