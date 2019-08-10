
/*
Create a repository
*/

resource "canzea_resource" "source_organization" {
  path = "/source/organization"

  attributes = {
    description = "string"
    full_name = "Ecosystem ${var.es_id} Operations"
    location = "string"
    username = "ecosystem_operations"
    website = "string"
  }

  id_attribute = "username"
}

resource "canzea_resource" "source_org_webhook" {
  path = "/source/webhook/${canzea_resource.source_organization.id}"

  attributes = {
    #type = "gitea"
    url = "https://providergw.cloud.${var.domain_name}/gw/hooks/01/gitea"
    content_type = "json"
    secret = "${vault_approle_auth_backend_login.login.client_token}"
    events = "create,delete,fork,push,issues,issue_comment,pull_request,repository,release"
    #active = true
  }
}

resource "canzea_resource" "source_repository" {
  path = "/source/repository/${canzea_resource.source_organization.id}"

  attributes = {
    auto_init = true
    description = "cicd-pipelines"
    private = true
    readme = "Default"
    name = "cicd-pipelines"
  }

  id_attribute = "name"
}

resource "canzea_resource" "deploy_key" {
  path = "/source/deploy_key/${canzea_resource.source_organization.id}/${canzea_resource.source_repository.id}"

  attributes = {
    project = "ecosystem_operations/cicd-pipelines"
    readonly = true
    title   = "Deploy key for cicd-pipelines"
    key     = "${var.gocd_public_key_openssh}"
  }
}


output "ssh_url" {
  value = "${canzea_resource.source_repository.api_data["ssh_url"]}"
}
