output "admin_password" {
    value = "${random_string.admin_password.result}"
}