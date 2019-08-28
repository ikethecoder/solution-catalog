resource "canzea_resource" "cicd-pipeline-rpa-brain" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/build/pipeline-rpa-brain.gocd.yaml"
        definition = "${data.template_file.rpa-brain.rendered}"
    }
}


data "template_file" "rpa-brain" {
  template = "${file("${path.module}/rpa/brain.yaml")}"
  vars = {
    tenant_id = "${var.tenant_id}"
  }
}

resource "canzea_resource" "cicd-pipeline-rpa-channel" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/build/pipeline-rpa-channel.gocd.yaml"
        definition = "${data.template_file.rpa-channel.rendered}"
    }
}


data "template_file" "rpa-channel" {
  template = "${file("${path.module}/rpa/channel.yaml")}"
  vars = {
    tenant_id = "${var.tenant_id}"
  }
}

resource "canzea_resource" "cicd-pipeline-rpa-listen" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/build/pipeline-rpa-listen.gocd.yaml"
        definition = "${data.template_file.rpa-listen.rendered}"
    }
}


data "template_file" "rpa-listen" {
  template = "${file("${path.module}/rpa/listen.yaml")}"
  vars = {
    tenant_id = "${var.tenant_id}"
  }
}

resource "canzea_resource" "cicd-pipeline-rpa-speak" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/build/pipeline-rpa-speak.gocd.yaml"
        definition = "${data.template_file.rpa-speak.rendered}"
    }
}


data "template_file" "rpa-speak" {
  template = "${file("${path.module}/rpa/speak.yaml")}"
  vars = {
    tenant_id = "${var.tenant_id}"
  }
}

resource "canzea_resource" "cicd-pipeline-rpa-ui" {
    path = "/cicd/config"

    attributes = {
        filename = "ecosystems/${var.es_id}/workspaces/build/pipeline-rpa-ui.gocd.yaml"
        definition = "${data.template_file.rpa-ui.rendered}"
    }
}


data "template_file" "rpa-ui" {
  template = "${file("${path.module}/rpa/ui.yaml")}"
  vars = {
    tenant_id = "${var.tenant_id}"
  }
}

resource "canzea_resource" "cicd-environments-build-rpa" {
  path = "/cicd/config"

  attributes = {
      filename = "ecosystems/${var.es_id}/workspaces/build/rpa-environment.gocd.yaml"
      role_id = "${var.cicd_encrypted_role_id}"
      definition = <<-EOT

            format_version: 3
            environments:
                ${var.tenant_id}-build-rpa:
                    environment_variables:
                        VAULT_ADDR: https://vault.ops.${var.domain_name}
                        REGISTRY: registry.ops.${var.domain_name}
                    pipelines:
                        - ${var.tenant_id}-rpa-brain
                        - ${var.tenant_id}-rpa-channel
                        - ${var.tenant_id}-rpa-listen
                        - ${var.tenant_id}-rpa-speak
                        - ${var.tenant_id}-rpa-ui
        EOT
  }
}
