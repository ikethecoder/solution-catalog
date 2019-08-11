
resource "canzea_resource" "source_repository_canzea_pipelines" {
  path = "/source/mirror/${var.source_org_id}"

  attributes = {
    clone_addr = "https://gitlab.com/ikethecoder/canzea-pipelines.git"
    repo_name = "canzea-pipelines"
    auth_username = "token"
    auth_password = "${var.gitlab["password"]}"
    private = true
    uid = "${var.source_org_id}"
  }

  id_attribute = "name"
}

resource "canzea_resource" "canzea_pipelines_deploy_key_config" {
  path = "/source/deploy_key/${var.source_org_id}/${canzea_resource.source_repository_canzea_pipelines.id}"

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
      role_id = "${var.cicd_encrypted_role_id}"
      definition = <<-EOT

            format_version: 3
            environments:
                ${var.tenant_id}-build:
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
                    - ${var.tenant_id}-canzea-public
                    - ${var.tenant_id}-console-ui
                #      - console-app-es1122


        EOT
  }

  depends_on = [
    "canzea_resource.source_repository_canzea_pipelines"
  ]
}

