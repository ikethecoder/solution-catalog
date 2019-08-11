output tenant_role_id {
    value = "${vault_approle_auth_backend_role.tenant.role_id}"
}

output tenant_secret_id {
    value = "${vault_approle_auth_backend_role_secret_id.tenant.secret_id}"
}
