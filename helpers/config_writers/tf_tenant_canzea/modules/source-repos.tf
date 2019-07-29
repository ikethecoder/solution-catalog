
/*
Create a repository
*/

resource "canzea_resource" "source_organization_es3333" {
  path = "/source/organization"

  attributes = {
    description = "string"
    full_name = "Ecosystem es3333 Operations"
    location = "string"
    username = "ecosystem_operations"
    website = "string"
  }

  id_attribute = "username"
}

resource "canzea_resource" "source_org_webhook_es3333" {
  path = "/source/webhook/${canzea_resource.source_organization_es3333.id}"

  attributes = {
    #type = "gitea"
    url = "https://providergw.cloud.${var.domain_name}/gw/hooks/gitea"
    content_type = "json"
    secret = "123"
    events = "create,delete,fork,push,issues,issue_comment,pull_request,repository,release"
    #active = true
  }
}

resource "canzea_resource" "source_repository_es3333" {
  path = "/source/repository/${canzea_resource.source_organization_es3333.id}"

  attributes = {
    auto_init = true
    description = "cicd-pipelines"
    private = true
    readme = "Default"
    name = "cicd-pipelines"
  }

  id_attribute = "name"
}

resource "canzea_resource" "deploy_key_es3333" {
  path = "/source/deploy_key/${canzea_resource.source_organization_es3333.id}/${canzea_resource.source_repository_es3333.id}"

  attributes = {
    project = "ecosystem_operations/cicd-pipelines"
    readonly = true
    title   = "Deploy key for cicd-pipelines"
    key     = "${var.gocd_public_key_openssh}"
  }
}


output "ssh_url" {
  value = "${canzea_resource.source_repository_es3333.api_data["ssh_url"]}"
}