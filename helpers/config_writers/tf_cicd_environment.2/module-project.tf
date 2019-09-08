module "project-{{tenant_id}}-{{rid}}" {
        source = "./modules/project/pipeline"
        vault_token = "${data.http.root_token.body}"
        es_id = "${var.es_id}"
        domain_name = "${var.domain_name}"
        tenant_id = "{{tenant_id}}"
        project = "{{rid}}"
        repo = {
                url = "{{repo_url}}"
                branch = "{{repo_branch}}"
        }
        deploy_workspace = "{{deploy_workspace}}"
        dns_prefix = "{{dns_prefix}}"

        cicd_encrypted_role_id = "${module.tenant-base.cicd_encrypted_role_id}"
        cicd_encrypted_secret_id = "${module.tenant-base.cicd_encrypted_secret_id}"

}
