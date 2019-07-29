resource "random_string" "keycloakAdminPassword" {
  length = 16
  special = false
  override_special = "/@\" "
}

resource "random_string" "postgresAppPassword" {
  length = 16
  special = false
  override_special = "/@\" "
}

resource "helm_release" "keycloak" {
    name      = "keycloak"
    chart     = "stable/keycloak"
    namespace = "iam"

    values = [
        <<EOF
         postgresql:
           postgresPassword: "${random_string.postgresAppPassword.result}"
         keycloak:
           ingress:
             enabled: true
             hosts:
             - auth.cloud.${var.domain_name}
           username: kcadmin
           password: ${random_string.keycloakAdminPassword.result}
        EOF
    ]

    set {
        name  = "keycloak.persistence.dbVendor"
        value = "postgres"
    }

    set {
        name  = "keycloak.persistence.deployPostgres"
        value = "true"
    }

    depends_on = [
      "null_resource.helm_init"
    ]
}
