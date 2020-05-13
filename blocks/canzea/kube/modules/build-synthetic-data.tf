
data "template_file" "synthetic-data" {
  template = "${file("${path.module}/data-synthetic-data/pipeline.yaml")}"
  vars = {
    es_id = "${var.es_id}"
    domain_name = "${var.domain_name}"
    tenant_id = "${var.tenant_id}"
    workspace = "${var.workspace}"
    deploy_workspace = "${var.workspace}"
    project = "synthetic-data"
    dns_prefix = "synthetic-data"
    cdn_path = "synthetic-data"
  }
}

resource "canzea_resource" "cicd-pipeline-synthetic-data" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/${var.workspace}/pipeline-synthetic-data.gocd.yaml"
        definition = "${data.template_file.synthetic-data.rendered}"
    }
}
