
resource "canzea_resource" "cicd-config-repos-core" {
  path = "/cicd/config_repo"

  attributes = {
      name = "core"
      url = "git@gitlab.com:ikethecoder/yamya-infra.git"
      branch = "develop"
  }
}

resource "canzea_resource" "cicd-config-repos-canzea" {
  path = "/cicd/config_repo"

  attributes = {
      name = "canzea"
      url = "git@gitlab.com:ikethecoder/canzea-pipelines.git"
      branch = "develop"
  }
}

resource "canzea_resource" "cicd-config-repos-ecosystem-ops" {
  path = "/cicd/config_repo"

  attributes = {
      name = "ecosyste_ops"
      url = "${canzea_resource.source_repository_es3333.api_data["ssh_url"]}"
      branch = "master"
  }
}
