

resource "canzea_resource" "cicd-config-repos-canzea" {
  path = "/cicd/config_repo"

  attributes = {
      name = "canzea"
      url = "${canzea_resource.source_repository_canzea_pipelines.api_data["ssh_url"]}"
      branch = "develop"
  }
}

resource "canzea_resource" "cicd-config-repos-ecosystem-ops" {
  path = "/cicd/config_repo"

  attributes = {
      name = "ecosystem_ops"
      url = "${canzea_resource.source_repository.api_data["ssh_url"]}"
      branch = "master"
  }
}
