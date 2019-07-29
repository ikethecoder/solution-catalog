
resource "null_resource" "realm-exec" {

  triggers = {
      "script_change" = "${md5(file("${path.module}/scripts/realm-setup.py"))}"
  }

  provisioner "local-exec" {
    command = "pip3 install requests && python3 ${path.module}/scripts/realm-setup.py ${var.realm}"

    environment = {
        "_WAIT_HACK" = "${var.module_depends_on}"
        "AUTH_HOST" = "${var.auth_host}"
        "ADMIN_USERNAME" = "${var.admin_username}"
        "ADMIN_PASSWORD" = "${var.admin_password}"
    }

  }

}

