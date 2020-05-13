


data "template_file" "deploy-mini-functions" {
  template = "${file("${path.module}/mini-functions/pipeline-deploy.yaml")}"
  vars = {
    es_id = "${var.es_id}"
    domain_name = "${var.domain_name}"
    tenant_id = "${var.tenant_id}"
    workspace = "${var.workspace}"
    deploy_workspace = "${var.workspace}"
    project = "mini-functions"
    dns_prefix = "func"
    cdn_path = "public"
  }
}

resource "canzea_resource" "cicd-pipeline-deploy-mini-functions" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/${var.workspace}/pipeline-mini-functions.gocd.yaml"
        definition = "${data.template_file.deploy-mini-functions.rendered}"
    }
}

