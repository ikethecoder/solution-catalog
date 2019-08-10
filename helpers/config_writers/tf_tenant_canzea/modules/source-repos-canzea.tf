
resource "canzea_resource" "source_repository_canzea_pipelines" {
  path = "/source/mirror/${canzea_resource.source_organization.id}"

  attributes = {
    clone_addr = "https://gitlab.com/ikethecoder/canzea-pipelines.git"
    repo_name = "canzea-pipelines"
    auth_username = "token"
    auth_password = "${var.gitlab["password"]}"
    private = true
    uid = "${canzea_resource.source_organization.api_data["id"]}"
  }

  id_attribute = "name"
}

resource "canzea_resource" "canzea_pipelines_deploy_key_config" {
  path = "/source/deploy_key/${canzea_resource.source_organization.id}/${canzea_resource.source_repository_canzea_pipelines.id}"

  attributes = {
    project = "ecosystem_operations/canzea-pipelines"
    readonly = true
    title   = "Deploy key for canzea-pipelines"
    key     = "${var.gocd_public_key_openssh}"
  }
}

resource "canzea_resource" "canzea_pipelines_environments" {
  path = "/artifacts"

  attributes = {
      repository = "canzea-pipelines"
      branch = "develop"
      filename = "environments/build.gocd.yaml"
      role_id = "${canzea_static_resource.cicd-encrypted-role-id.api_data["encrypted_value"]}"
      definition = <<-EOT

            format_version: 3
            environments:
                build-${var.es_id}:
                    environment_variables:
                        VAULT_ADDR: https://vault.ops.${var.domain_name}
                        REGISTRY: registry.ops.${var.domain_name}
                        secure_variables:
                        VAULT_TOKEN: ""
                    pipelines:
                    - canzea-cli
                    - gocd-generic-oauth-authorization-plugin
                    - helm-charts
                    - ikform
                    - iksplor
                    - node-red-contrib-canzea-vars
                    - terraform-provider-canzea
                    - topbar
                    - provider-gateway
                    - canzea-public-es1122
                    - console-ui-es1122
                #      - console-app-es1122


        EOT
  }

  depends_on = [
    "canzea_resource.source_repository_canzea_pipelines"
  ]
}

resource "canzea_resource" "canzea_pipelines_environments_rpa" {
  path = "/artifacts"

  attributes = {
      repository = "canzea-pipelines"
      branch = "develop"
      filename = "environments/build-rpa.gocd.yaml"
      role_id = "${canzea_static_resource.cicd-encrypted-role-id.api_data["encrypted_value"]}"
      definition = <<-EOT

            format_version: 3
            environments:
                build-rpa-${var.es_id}:
                    environment_variables:
                        VAULT_ADDR: https://vault.ops.${var.domain_name}
                        REGISTRY: registry.ops.${var.domain_name}
                    secure_variables:
                        VAULT_TOKEN: ""
                    pipelines:
                    - rpa-brain-es1122
                    - rpa-channel-es1122
                    - rpa-listen-es1122
                    - rpa-speak-es1122
                    - rpa-ui-es1122

        EOT
  }

  depends_on = [
    "canzea_resource.source_repository_canzea_pipelines"
  ]
}
