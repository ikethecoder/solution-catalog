resource "canzea_resource" "cicd-pipeline-deploy-rpa-brain" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/${var.workspace}/pipeline-rpa-brain.gocd.yaml"
        definition = "${data.template_file.deploy-rpa-brain.rendered}"
    }
}


data "template_file" "deploy-rpa-brain" {
  template = "${file("${path.module}/rpa-deploy/pipeline.yaml")}"
  vars = {
    es_id = "${var.es_id}"
    domain_name = "${var.domain_name}"
    tenant_id = "${var.tenant_id}"
    workspace = "${var.workspace}"
    deploy_workspace = "intg"
    project = "rpa-brain"
    dns_prefix = "rpa-brain"
    cdn_path = "public"
  }
}


resource "canzea_resource" "cicd-pipeline-deploy-rpa-channel" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/${var.workspace}/pipeline-rpa-channel.gocd.yaml"
        definition = "${data.template_file.deploy-rpa-channel.rendered}"
    }
}


data "template_file" "deploy-rpa-channel" {
  template = "${file("${path.module}/rpa-deploy/pipeline.yaml")}"
  vars = {
    es_id = "${var.es_id}"
    domain_name = "${var.domain_name}"
    tenant_id = "${var.tenant_id}"
    workspace = "${var.workspace}"
    deploy_workspace = "intg"
    project = "rpa-channel"
    dns_prefix = "rpa-channel"
    cdn_path = "public"
  }
}


resource "canzea_resource" "cicd-pipeline-deploy-rpa-listen" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/${var.workspace}/pipeline-rpa-listen.gocd.yaml"
        definition = "${data.template_file.deploy-rpa-listen.rendered}"
    }
}


data "template_file" "deploy-rpa-listen" {
  template = "${file("${path.module}/rpa-deploy/pipeline.yaml")}"
  vars = {
    es_id = "${var.es_id}"
    domain_name = "${var.domain_name}"
    tenant_id = "${var.tenant_id}"
    workspace = "${var.workspace}"
    deploy_workspace = "intg"
    project = "rpa-listen"
    dns_prefix = "rpa-listen"
    cdn_path = "public"
  }
}


resource "canzea_resource" "cicd-pipeline-deploy-rpa-speak" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/${var.workspace}/pipeline-rpa-speak.gocd.yaml"
        definition = "${data.template_file.deploy-rpa-speak.rendered}"
    }
}


data "template_file" "deploy-rpa-speak" {
  template = "${file("${path.module}/rpa-deploy/pipeline.yaml")}"
  vars = {
    es_id = "${var.es_id}"
    domain_name = "${var.domain_name}"
    tenant_id = "${var.tenant_id}"
    workspace = "${var.workspace}"
    deploy_workspace = "intg"
    project = "rpa-speak"
    dns_prefix = "rpa-speak"
    cdn_path = "public"
  }
}


resource "canzea_resource" "cicd-pipeline-deploy-rpa-ui" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/${var.workspace}/pipeline-rpa-ui.gocd.yaml"
        definition = "${data.template_file.deploy-rpa-ui.rendered}"
    }
}


data "template_file" "deploy-rpa-ui" {
  template = "${file("${path.module}/rpa-deploy/pipeline.yaml")}"
  vars = {
    es_id = "${var.es_id}"
    domain_name = "${var.domain_name}"
    tenant_id = "${var.tenant_id}"
    workspace = "${var.workspace}"
    deploy_workspace = "intg"
    project = "rpa-ui"
    dns_prefix = "rpa-ui"
    cdn_path = "public"
  }
}



resource "canzea_resource" "cicd-environments-deploy-rpa" {
  path = "/cicd/config"

  attributes = {
      filename = "ecosystems/${var.es_id}/workspaces/${var.workspace}/rpa-environment.gocd.yaml"
      role_id = "${var.cicd_encrypted_role_id}"
      definition = <<-EOT

            format_version: 3
            environments:
                ${var.tenant_id}-${var.workspace}-rpa:
                    environment_variables:
                        VAULT_ADDR: "https://vault.ops.${var.domain_name}"
                        REGISTRY: "registry.ops.${var.domain_name}"
                    secure_variables:
                        VAULT_ROLE_ID: "${var.cicd_encrypted_role_id}"
                        VAULT_SECRET_ID: "${var.cicd_encrypted_secret_id}"
                    pipelines:
                    - ${var.tenant_id}-rpa-brain-${var.workspace}
                    - ${var.tenant_id}-rpa-channel-${var.workspace}
                    - ${var.tenant_id}-rpa-listen-${var.workspace}
                    - ${var.tenant_id}-rpa-speak-${var.workspace}
                    - ${var.tenant_id}-rpa-ui-${var.workspace}
        EOT
  }
}
