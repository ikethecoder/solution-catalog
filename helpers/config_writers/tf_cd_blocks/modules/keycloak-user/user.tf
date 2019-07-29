
resource "random_string" "user_password" {
  length = 30
  special = false
  override_special = "/@\" "
}

resource "null_resource" "user-exec" {

  triggers = {
      "script_change" = "${md5(file("${path.module}/scripts/user-setup.py"))}"
  }

  provisioner "local-exec" {
    command = "pip3 install requests && python3 ${path.module}/scripts/user-setup.py"

    environment = {
        "_WAIT_HACK" = "${var.module_depends_on}"
        "REALM" = "${var.realm}"
        "USER_USERNAME" = "${var.username}"
        "USER_PASSWORD" = "${random_string.user_password.result}"
        "AUTH_HOST" = "${var.auth_host}"
        "ADMIN_USERNAME" = "${var.admin_username}"
        "ADMIN_PASSWORD" = "${var.admin_password}"
    }

  }

}

