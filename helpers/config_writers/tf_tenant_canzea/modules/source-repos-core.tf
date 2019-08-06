
resource "canzea_resource" "source_repository_canzea_gocd_config_mirror" {
  path = "/source/mirror/${canzea_resource.source_organization_es3333.id}"

  attributes = {
    clone_addr = "https://github.com/ikethecoder/canzea-gocd-config.git"
    repo_name = "canzea-gocd-config"
    private = true
    uid = "${canzea_resource.source_organization_es3333.api_data["id"]}"
  }

  id_attribute = "name"
}

resource "canzea_resource" "deploy_key_config" {
  path = "/source/deploy_key/${canzea_resource.source_organization_es3333.id}/${canzea_resource.source_repository_canzea_gocd_config_mirror.id}"

  attributes = {
    project = "ecosystem_operations/canzea-gocd-config"
    readonly = true
    title   = "Deploy key for canzea-gocd-config"
    key     = "${var.gocd_public_key_openssh}"
  }
}

resource "canzea_resource" "cicd_environments_canzea_gocd_config" {
  path = "/artifacts"

  attributes = {
      repository = "canzea-gocd-config"
      filename = "cicd-agents/environment.gocd.yaml"
      role_id = "${canzea_static_resource.cicd-encrypted-role-id.api_data["encrypted_value"]}"
      definition = <<-EOT

            format_version: 3
            environments:
              cicd:
                environment_variables:
                  GIT_REPO: ${canzea_resource.source_repository_es3333.api_data["ssh_url"]}
                  GIT_BRANCH: master
                  REGISTRY: registry.ops.${var.domain_name}
                pipelines:
                  - agent-stack-golang111
                  - agent-stack-java8
                  - agent-stack-nodejs8
                  - agent-stack-python37
                  - agent-stack-ruby25
                  - agent-static-hugo
                  - agent-helm211
                  - agent-terraform
                  - agent-cloud-aws
                  - agent-cloud-digitalocean
                  - agent-vault

        EOT
  }

  depends_on = [
    "canzea_resource.source_repository_canzea_gocd_config_mirror"
  ]
}
