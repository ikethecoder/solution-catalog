
resource "random_string" "admin_password" {
  length = 16
  special = false
  override_special = "/@\" "
}

resource "null_resource" "gitea-first-login" {

  triggers = {
      "script_change" = "${md5(file("${path.module}/scripts/first-login.py"))}"
  }

  provisioner "local-exec" {
    command = "pip3 install requests bs4 && python3 ${path.module}/scripts/first-login.py"

    environment = {
      "_WAIT" = "${var.module_depends_on}"
      "GITEA_HOST" = "${var.gitea_host}"
      "ADMIN_USERNAME" = "${var.admin_username}"
      "ADMIN_EMAIL" = "${var.admin_email}"
      "ADMIN_PASSWORD" = "${random_string.admin_password.result}"
    }
  }
}

resource "null_resource" "gitea-set-auth" {

  triggers = {
      "script_change" = "${md5(file("${path.module}/scripts/set-auth.py"))}"
  }

  provisioner "local-exec" {
    command = "pip3 install requests bs4 && python3 ${path.module}/scripts/set-auth.py"

    environment = {
      "GITEA_HOST" = "${var.gitea_host}"
      "OIDC_ISSUER" = "${var.oidc_issuer}"
      "OIDC_CLIENT_ID" = "${var.oidc_client_id}"
      "OIDC_CLIENT_SECRET" = "${var.oidc_client_secret}"
      "ADMIN_USERNAME" = "${var.admin_username}"
      "ADMIN_PASSWORD" = "${random_string.admin_password.result}"
    }
  }

  depends_on = [
    "null_resource.gitea-first-login"
  ]
}
