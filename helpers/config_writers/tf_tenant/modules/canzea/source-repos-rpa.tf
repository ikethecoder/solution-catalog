resource "canzea_resource" "canzea_pipelines_environments_rpa" {
  path = "/artifacts"

  attributes = {
      repository = "canzea-pipelines"
      branch = "develop"
      filename = "environments/build-rpa.gocd.yaml"
      role_id = "${var.cicd_encrypted_role_id}"
      definition = <<-EOT

            format_version: 3
            environments:
                ${var.tenant_id}-build-rpa:
                    environment_variables:
                        VAULT_ADDR: https://vault.ops.${var.domain_name}
                        REGISTRY: registry.ops.${var.domain_name}
                    pipelines:
                    - ${var.tenant_id}-rpa-brain
                    - ${var.tenant_id}-rpa-channel
                    - ${var.tenant_id}-rpa-listen
                    - ${var.tenant_id}-rpa-speak
                    - ${var.tenant_id}-rpa-ui

        EOT
  }

  depends_on = [
    "canzea_resource.source_repository_canzea_pipelines"
  ]
}
