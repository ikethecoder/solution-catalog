
/*
Create a repository
*/

resource "canzea_resource" "source_org_webhook" {
  path = "/source/webhook/${var.source_org_name}"

  attributes = {
    #type = "gitea"
    url = "https://providergw.cloud.${var.domain_name}/gw/hooks/${var.tenant_id}/gitea"
    content_type = "json"
    secret = "${var.vault_token}"
    events = "create,delete,fork,push,issues,issue_comment,pull_request,repository,release"
    #active = true
  }
}


resource "canzea_resource" "source_repository" {
  path = "/source/repository/${var.source_org_name}"

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
  path = "/source/deploy_key/${var.source_org_name}/${canzea_resource.source_repository.id}"

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
