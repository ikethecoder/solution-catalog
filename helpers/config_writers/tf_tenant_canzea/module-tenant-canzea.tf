module "tenant-canzea" {
  source  = "./modules/tenants/canzea"

  es_id = "${var.es_id}"
  domain_name = "${var.domain_name}"

  one_time_token_retrieval = "${module.cd.one_time_token_retrieval}"

  gocd_public_key_openssh = "${module.saas-providers.gocd_public_key_openssh}"

  gitlab = "${var.gitlab}"

  workspace = "${var.workspace}"

  tenant_id = "01"
}