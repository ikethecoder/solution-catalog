

resource "canzea_static_resource" "cicd-encrypted-role-id" {
  path = "/cicd_encrypted_value"
  attributes = {
      value = "${vault_approle_auth_backend_role.example.role_id}"
  }
}

resource "canzea_static_resource" "cicd-encrypted-secret-id" {
  path = "/cicd_encrypted_value"
  attributes = {
      value = "${vault_approle_auth_backend_role_secret_id.id.secret_id}"
  }
}

/*
Environment needs to be part of the config_repo!

        "pipelines": [
                {
                    "name": "canzea-index-es1122-dev"
                }
        ]

resource "canzea_resource" "cicd-environments-es2222-dev" {
  path = "/cicd/environment"

  attributes = {
      name = "es2222-dev"
      role_id = "${canzea_static_resource.cicd-encrypted-role-id.api_data["encrypted_value"]}"
      definition = <<-EOT
        {
            "pipelines" : [
            ],
            "environment_variables" : [
                {
                    "name" : "VAULT_ADDR",
                    "value" : "https://vault.ops.${var.domain_name}",
                    "secure" : false
                },
                {
                    "name" : "REGISTRY",
                    "value" : "registry.ops.${var.domain_name}",
                    "secure" : false
                },
                {
                    "name" : "VAULT_ROLE_ID",
                    "value" : "${canzea_static_resource.cicd-encrypted-role-id.api_data["encrypted_value"]}",
                    "secure" : true
                },
                {
                    "name" : "VAULT_SECRET_ID",
                    "value" : "${canzea_static_resource.cicd-encrypted-secret-id.api_data["encrypted_value"]}",
                    "secure" : true
                }
            ]
        }
        EOT
  }

  id_attribute = "name"
}
*/