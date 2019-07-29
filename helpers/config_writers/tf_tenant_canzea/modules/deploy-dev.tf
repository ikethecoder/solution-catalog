# https://www.npmjs.com/package/simple-git


# add environments and pipelines to config_repo ecosystem_operations


resource "canzea_resource" "cicd-environments-es2222-dev-file" {
  path = "/cicd/config"

  attributes = {
      filename = "ecosystems/es1122/workspaces/dev/environment.gocd.yaml"
      role_id = "${canzea_static_resource.cicd-encrypted-role-id.api_data["encrypted_value"]}"
      definition = <<-EOT

            format_version: 3
            environments:
                es2222-dev-x:
                    environment_variables:
                        VAULT_ADDR: "https://vault.ops.${var.domain_name}"
                        REGISTRY: "registry.ops.${var.domain_name}"
                    secure_variables:
                        VAULT_ROLE_ID: "${canzea_static_resource.cicd-encrypted-role-id.api_data["encrypted_value"]}"
                        VAULT_SECRET_ID: "${canzea_static_resource.cicd-encrypted-secret-id.api_data["encrypted_value"]}"
                    pipelines:
                    - es1122-canzea-public-dev
                    - es1122-dynamic-db-dev
                    - es1122-job-manager-dev
                    - es1122-saas-express-dev
                    - es1122-console-app-mongodb-dev
                    - es1122-console-app-rabbitmq-dev
                    - es1122-console-ui-dev
        EOT
  }
}
