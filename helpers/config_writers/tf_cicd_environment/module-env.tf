module "env-{{tenant_id}}-{{rid}}" {
        source = "./modules/cicd_environment.3"
        vault_token = "${data.http.root_token.body}"
        es_id = "${var.es_id}"
        domain_name = "${var.domain_name}"
        tenant_id = "{{tenant_id}}"
        project = "{{rid}}"

        workspace = "{{workspace}}"

        pipelines = []

        cicd_encrypted_role_id = "${module.tenant-base.cicd_encrypted_role_id}"
        cicd_encrypted_secret_id = "${module.tenant-base.cicd_encrypted_secret_id}"

}
