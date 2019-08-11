resource "canzea_resource" "cicd-environments-build-new" {
  path = "/cicd/config"

  attributes = {
      filename = "ecosystems/${var.es_id}/workspaces/build/environment.gocd.yaml"
      role_id = "${var.cicd_encrypted_role_id}"
      definition = <<-EOT

            format_version: 3
            environments:
                ${var.tenant_id}-build:
                    environment_variables:
                        VAULT_ADDR: https://vault.ops.${var.domain_name}
                        REGISTRY: registry.ops.${var.domain_name}
                    pipelines:
                        - ${var.tenant_id}-dynamic-db
                        - ${var.tenant_id}-job-manager
                        - ${var.tenant_id}-saas-express
        EOT
  }
}