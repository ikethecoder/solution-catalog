resource "canzea_resource" "cicd-environments-build-new" {
  path = "/cicd/config"

  attributes = {
      filename = "ecosystems/es1122/workspaces/build/environment.gocd.yaml"
      role_id = "${canzea_static_resource.cicd-encrypted-role-id.api_data["encrypted_value"]}"
      definition = <<-EOT

            format_version: 3
            environments:
                build-new-es1122:
                    environment_variables:
                        VAULT_ADDR: https://vault.ops.184768.xyz
                        REGISTRY: registry.ops.184768.xyz
                    pipelines:
                        - dynamic-db-es1122
                        - job-manager-es1122
                        - saas-express-es1122
        EOT
  }
}