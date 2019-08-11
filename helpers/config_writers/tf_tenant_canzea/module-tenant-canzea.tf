module "tenant-canzea" {
  source  = "./modules/tenants/canzea"

  es_id = "${var.es_id}"
  domain_name = "${var.domain_name}"

  vault_token = "${data.http.root_token.body}"

  gocd_public_key_openssh = "${module.saas-providers.gocd_public_key_openssh}"

  gitlab = "${var.gitlab}"

  workspace = "${var.workspace}"

  tenant_id = "{{tenant_id}}"

}

data "http" "root_token" {
  url = "https://helm.ops.${var.domain_name}/temp/${module.cd-bootstrap.one_time_token_retrieval}.txt"

  request_headers {
    "Accept" = "text/plain"
  }
}

module "tenant-canzea-access" {
  source  = "./modules/tenants/access"

  domain_name = "${var.domain_name}"

  one_time_token_retrieval = "${module.cd-bootstrap.one_time_token_retrieval}"

  tenant_role_id = "${module.onboard-tenant-canzea.tenant_role_id}"
  tenant_secret_id = "${module.onboard-tenant-canzea.tenant_secret_id}"
}
