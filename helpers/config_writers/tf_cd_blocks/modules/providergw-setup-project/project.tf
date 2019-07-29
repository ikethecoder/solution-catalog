resource "null_resource" "providergw-project" {

  triggers = {
      "script_change" = "${md5(file("${path.module}/scripts/add-project.py"))}"
  }

  provisioner "local-exec" {
    command = "pip3 install requests bs4 && python3 ${path.module}/scripts/add-project.py"

    environment = {
      "_WAIT" = "${var.module_depends_on}"
      "PROVIDERGW_HOST" = "${var.providergw_host}"
      "ADMIN_USERNAME" = "${var.admin_username}"
      "ADMIN_PASSWORD" = "${var.admin_password}"
      "GIT_USER" = "${var.flows_git["user"]}"
      "GIT_EMAIL" = "${var.flows_git["email"]}"
      "GIT_NAME" = "${var.flows_git["name"]}"
      "GIT_URL" = "${var.flows_git["url"]}"
      "GIT_SECRET" = "${var.flows_git["secret"]}"
      "GIT_USERNAME" = "${var.gitlab_username}"
      "GIT_PASSWORD" = "${var.gitlab_password}"
    }
  }
}
