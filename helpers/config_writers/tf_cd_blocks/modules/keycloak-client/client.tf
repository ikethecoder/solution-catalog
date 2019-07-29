
resource "random_string" "client_secret" {
  length = 30
  special = false
  override_special = "/@\" "
}

resource "null_resource" "realm-exec" {

  triggers = {
      "script_change" = "${md5(file("${path.module}/scripts/client-setup.py"))}"
  }

  provisioner "local-exec" {
    command = "pip3 install requests && python3 ${path.module}/scripts/client-setup.py ${var.realm} ${var.client}"

    environment = {
        "_WAIT_HACK" = "${var.module_depends_on}"
        "CLIENT_SECRET" = "${random_string.client_secret.result}"
        "AUTH_HOST" = "${var.auth_host}"
        "ADMIN_USERNAME" = "${var.admin_username}"
        "ADMIN_PASSWORD" = "${var.admin_password}"
    }

  }

}

