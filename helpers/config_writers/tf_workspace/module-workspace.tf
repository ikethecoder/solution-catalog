module "workspace-{{workspace}}" {
  source  = "./modules/workspace"

  es_id = "${var.es_id}"
  domain_name = "${var.domain_name}"

  workspace = "{{workspace}}"

  email = "{{email}}"

  #vault_token = "${module.tenant-canzea.temp_token}"
  vault_token = "${data.http.root_token.body}"


  do = "${var.do}"

  region = "{{region}}"
  node_pool_size = "{{node_pool_size}}"
  node_pool_count = "{{node_pool_count}}"
  kube_version = "{{kube_version}}"

  acme_account_key = "${module.cd.acme_account_key}"
}
