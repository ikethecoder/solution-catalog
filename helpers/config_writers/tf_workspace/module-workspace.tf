module "workspace-{{workspace}}" {
  source  = "./modules/workspace"

  es_id = "${var.es_id}"
  domain_name = "${var.domain_name}"

  workspace = "{{workspace}}"

  email = "ikethecoder@canzea.com"

  vault_token = "${module.tenant-canzea.temp_token}"


  do = "${var.do}"

  # region = {{region}}
  # node_pool_size = "{{node_pool_size}}"
  # node_pool_count = {{node_pool_count}}
  # kube_version = {{kube_version}}
  region = "lon1"
  kube_version = "1.14.4-do.1"
  node_pool_size = "s-4vcpu-8gb"
  node_pool_count = 1

  acme_account_key = "${module.cd.acme_account_key}"

}

data "http" "root_token" {
  url = "https://helm.ops.${var.domain_name}/temp/${module.cd.one_time_token_retrieval}.txt"

  request_headers {
    "Accept" = "text/plain"
  }

}

