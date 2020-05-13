
data "template_file" "data-mining" {
  template = "${file("${path.module}/data-mining/pipeline.yaml")}"
  vars = {
    es_id = "${var.es_id}"
    domain_name = "${var.domain_name}"
    tenant_id = "${var.tenant_id}"
    workspace = "${var.workspace}"
    deploy_workspace = "${var.workspace}"
    project = "data-mining"
    dns_prefix = "data-mining"
    cdn_path = "data-mining"
  }
}

resource "canzea_resource" "cicd-pipeline-data-mining" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/${var.workspace}/pipeline-data-mining.gocd.yaml"
        definition = "${data.template_file.data-mining.rendered}"
    }
}
