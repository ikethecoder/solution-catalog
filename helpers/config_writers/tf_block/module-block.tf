module "block-{{workspace}}-{{block}}" {
  source  = "./modules/blocks.2/{{block}}"

  es_id = "${var.es_id}"
  domain_name = "${var.domain_name}"

  workspace = "{{workspace}}"

  tenant_id = "{{tenant_id}}"

  #vault_token = "${module.tenant-canzea.temp_token}"
  vault_token = "${data.http.root_token.body}"
}
