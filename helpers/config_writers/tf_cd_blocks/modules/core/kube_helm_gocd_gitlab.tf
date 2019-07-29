/*
resource "gitlab_deploy_key" "yamya-infra" {
  project = "ikethecoder/yamya-infra"
  title   = "Deploy key for ${var.domain_name}"
  key     = "${tls_private_key.gocd_private_key.public_key_openssh}"
}
*/
# Configure the GitLab Provider
provider "gitlab" {
    token = "${var.gitlab["password"]}"
}

