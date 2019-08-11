# https://www.npmjs.com/package/simple-git


# add environments and pipelines to config_repo ecosystem_operations


resource "canzea_resource" "cicd-environments-dev-file" {
  path = "/cicd/config"

  attributes = {
      filename = "ecosystems/${var.es_id}/workspaces/dev/environment.gocd.yaml"
      role_id = "${var.cicd_encrypted_role_id}"
      definition = <<-EOT

            format_version: 3
            environments:
                ${var.tenant_id}-${var.deploy_workspace}:
                    environment_variables:
                        VAULT_ADDR: "https://vault.ops.${var.domain_name}"
                        REGISTRY: "registry.ops.${var.domain_name}"
                    secure_variables:
                        VAULT_ROLE_ID: "${var.cicd_encrypted_role_id}"
                        VAULT_SECRET_ID: "${var.cicd_encrypted_secret_id}"
                    pipelines:
                    - ${var.tenant_id}-canzea-public-${var.deploy_workspace}
                    - ${var.tenant_id}-dynamic-db-${var.deploy_workspace}
                    - ${var.tenant_id}-job-manager-${var.deploy_workspace}
                    - ${var.tenant_id}-saas-express-${var.deploy_workspace}
                    - ${var.tenant_id}-mongodb-${var.deploy_workspace}
                    - ${var.tenant_id}-rabbitmq-${var.deploy_workspace}
                    - ${var.tenant_id}-console-ui-${var.deploy_workspace}
        EOT
  }
}
