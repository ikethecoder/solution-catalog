# https://www.npmjs.com/package/simple-git


# add environments and pipelines to config_repo ecosystem_operations


resource "canzea_resource" "cicd-environment-deploy" {
  path = "/cicd/config"

  attributes = {
      filename = "ecosystems/${var.es_id}/workspaces/${var.deploy_workspace}/environment.gocd.yaml"
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
                    - ${var.tenant_id}-cci-public-${var.deploy_workspace}
        EOT
  }
}
