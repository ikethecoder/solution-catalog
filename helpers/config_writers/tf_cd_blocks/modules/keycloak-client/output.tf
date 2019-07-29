output "secret_key" {
    value = "${random_string.client_secret.result}"
}