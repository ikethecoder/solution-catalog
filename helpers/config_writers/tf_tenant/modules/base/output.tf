output "cicd_encrypted_role_id" {
    value = "${canzea_static_resource.cicd-encrypted-role-id.api_data["encrypted_value"]}"
}

output "cicd_encrypted_secret_id" {
    value = "${canzea_static_resource.cicd-encrypted-secret-id.api_data["encrypted_value"]}"
}

output "source_org_name" {
    value = "${canzea_resource.source_organization.id}"
}

output "source_org_id" {
    value = "${canzea_resource.source_organization.api_data["id"]}"
}