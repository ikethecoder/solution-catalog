
output "keycloak_issuer" {
    value = "https://auth.cloud.${var.domain_name}"
}

output "keycloak_admin_username" {
    value = "kcadmin"
}

output "keycloak_admin_password" {
    value = "${random_string.keycloakAdminPassword.result}"
}

output "gocd_admin_password" {
    value = "${random_string.gocd-admin-password.result}"
}

output "gocd_public_key_openssh" {
    value = "${tls_private_key.gocd_private_key.public_key_openssh}"
}

output "gitlab_access_token" {
    value = "${var.gitlab["password"]}"
}

output "milestone_keycloak_ready" {
    value = "READY"
    depends_on = [
        "helm_release.keycloak",
        "digitalocean_record.cluster"
    ]
}

output "milestone_gitea_ready" {
    value = "READY"
    depends_on = [
        "helm_release.gitea",
        "digitalocean_record.cluster"
    ]
}

output "milestone_gocd_ready" {
    value = "READY"
    depends_on = [
        "helm_release.gocd",
        "digitalocean_record.cluster"
    ]
}
