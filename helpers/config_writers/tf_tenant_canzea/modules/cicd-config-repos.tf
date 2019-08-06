
resource "canzea_resource" "cicd-config-repos-core" {
  path = "/cicd/config_repo"

  attributes = {
      name = "core"
      url = "${canzea_resource.source_repository_canzea_gocd_config_mirror.api_data["ssh_url"]}"
      branch = "master"
  }
}

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
      url = "${canzea_resource.source_repository_es3333.api_data["ssh_url"]}"
      branch = "master"
  }
}
