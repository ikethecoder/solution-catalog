resource "canzea_resource" "cicd-environment-build" {
  path = "/cicd/config"

  attributes = {
      filename = "ecosystems/${var.es_id}/workspaces/build/environment-${var.deploy_workspace}.gocd.yaml"
      role_id = "${var.cicd_encrypted_role_id}"
      definition = <<-EOT

            format_version: 3
            environments:
                ${var.tenant_id}-build-${var.deploy_workspace}:
                    environment_variables:
                        VAULT_ADDR: https://vault.ops.${var.domain_name}
                        REGISTRY: registry.ops.${var.domain_name}
                    pipelines:
                        - ${var.tenant_id}-cci-public
        EOT
  }
}
