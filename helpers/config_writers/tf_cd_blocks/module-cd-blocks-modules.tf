
module "saas-providers" {
  source  = "./modules/blocks/core"

  pvt_key_data = "${module.cd.pvt_key_data}"
  do_token = "${module.cd.do_token}"
  node_cluster = "${module.cd.node_cluster}"
  # node_cluster_collab = "${module.cd.node_cluster_collab}"
  base_droplet_id = "${module.cd.base_droplet_id}"
  domain_name = "${module.cd.domain_name}"
  kube_host = "${module.cd.kube_host}"
  kube_client_certificate = "${module.cd.kube_client_certificate}"
  kube_client_key = "${module.cd.kube_client_key}"
  kube_cluster_ca_certificate = "${module.cd.kube_cluster_ca_certificate}"
  domain_tls_certificate_pem = "${module.cd.domain_tls_certificate_pem}"
  domain_tls_private_key_pem = "${module.cd.domain_tls_private_key_pem}"
  domain_tls_issuer_pem = "${module.cd.domain_tls_issuer_pem}"
  base_proxy_ipv4_address = "${module.cd.base_proxy_ipv4_address}"

  acme_account_key = "${module.cd.acme_account_key}"
  
  gitlab = "${var.gitlab}"

  source_ssh_ip = "${module.cd.source_ssh_ip}"
}

module "gitea-first-login" {
  source = "./modules/blocks/gitea-first-login"
  gitea_host = "https://source.cloud.${module.cd.domain_name}"
  oidc_issuer = "${module.saas-providers.keycloak_issuer}/auth/realms/operations"
  oidc_client_id = "gitea"
  oidc_client_secret = "${module.bootstrap-gitea-client.secret_key}"
  admin_username = "scadmin"
  admin_email = "scadmin@nowhere.com"

  module_depends_on = "${module.saas-providers.milestone_keycloak_ready}${module.saas-providers.milestone_gitea_ready}"
}

module "providergw" {
  source = "./modules/blocks/providergw"

  domain_name = "${module.cd.domain_name}"

  kube_host = "${module.cd.kube_host}"
  kube_client_certificate = "${module.cd.kube_client_certificate}"
  kube_client_key = "${module.cd.kube_client_key}"
  kube_cluster_ca_certificate = "${module.cd.kube_cluster_ca_certificate}"

  oidc = {
    host = "${module.saas-providers.keycloak_issuer}"
    realm = "operations"
    client_id = "gateway"
    client_secret = "${module.bootstrap-gateway-client.secret_key}"
  }

  vault = {
    host = "https://vault.ops.${module.cd.domain_name}"
    token = "AA1234"
  }

  module_depends_on = "${module.saas-providers.milestone_keycloak_ready}"
}

module "bootstrap-gateway-realm" {
  source = "./modules/blocks/keycloak-realm"
  realm = "operations"
  auth_host = "auth.cloud.${module.cd.domain_name}"
  admin_username = "${module.saas-providers.keycloak_admin_username}"
  admin_password = "${module.saas-providers.keycloak_admin_password}"

  module_depends_on = "${module.saas-providers.milestone_keycloak_ready}"
}

module "bootstrap-gateway-client" {
  source = "./modules/blocks/keycloak-client"
  realm = "${module.bootstrap-gateway-realm.realm}"
  client = "gateway"
  auth_host = "auth.cloud.${module.cd.domain_name}"
  admin_username = "${module.saas-providers.keycloak_admin_username}"
  admin_password = "${module.saas-providers.keycloak_admin_password}"

  module_depends_on = "${module.bootstrap-gateway-realm.milestone_realm_created}"
}

module "bootstrap-gitea-client" {
  source = "./modules/blocks/keycloak-client"
  realm = "${module.bootstrap-gateway-realm.realm}"
  client = "gitea"
  auth_host = "auth.cloud.${module.cd.domain_name}"
  admin_username = "${module.saas-providers.keycloak_admin_username}"
  admin_password = "${module.saas-providers.keycloak_admin_password}"

  module_depends_on = "${module.bootstrap-gateway-realm.milestone_realm_created}"
}

module "bootstrap-gocd-client" {
  source = "./modules/blocks/keycloak-client"
  realm = "${module.bootstrap-gateway-realm.realm}"
  client = "gocd"
  auth_host = "auth.cloud.${module.cd.domain_name}"
  admin_username = "${module.saas-providers.keycloak_admin_username}"
  admin_password = "${module.saas-providers.keycloak_admin_password}"

  module_depends_on = "${module.bootstrap-gateway-realm.milestone_realm_created}"
}

module "vault-jwt" {
  source = "./modules/blocks/vault-jwt"

  pvt_key_data = "${module.cd.pvt_key_data}"
  base_proxy_ipv4_address = "${module.cd.base_proxy_ipv4_address}"

  oidc_discovery_url = "https://auth.cloud.${module.cd.domain_name}/auth/realms/${module.bootstrap-gateway-realm.realm}"

  module_depends_on = "${module.bootstrap-gateway-realm.milestone_realm_created}"
}

/*
module "pvc-cleanup" {
  source  = "/base/modules/pvc-cleanup"
}
*/

module "vault-init" {
  source = "./modules/blocks/vault-init"
  domain_name = "${module.cd.domain_name}"
  one_time_token_retrieval = "${module.cd.one_time_token_retrieval}"

  module_depends_on = "${module.cd.milestone_setup_complete}"

}

module "providergw-user" {
  source = "./modules/blocks/keycloak-user"
  username = "gwadmin"

  realm = "${module.bootstrap-gateway-realm.realm}"

  auth_host = "auth.cloud.${module.cd.domain_name}"
  admin_username = "${module.saas-providers.keycloak_admin_username}"
  admin_password = "${module.saas-providers.keycloak_admin_password}"

  module_depends_on = "${module.bootstrap-gateway-realm.milestone_realm_created}"

}

# A user needs to be created in keycloak before this can be called
module "providergw-setup-project" {
  source = "./modules/blocks/providergw-setup-project"
  providergw_host = "https://providergw.cloud.${module.cd.domain_name}"
  admin_username = "gwadmin"
  admin_password = "${module.providergw-user.password}"

  flows_git = "${var.flows_git}"
  gitlab_password = "${var.gitlab["password"]}"
  gitlab_username = "${var.gitlab["username"]}"

  module_depends_on = "${module.cd.milestone_setup_complete}${module.providergw.milestone_providergw_ready}${module.providergw-user.milestone_user_created}"

}


module "onboard-tenant-canzea" {
  source = "./modules/blocks/tenant"

  tenant = "01"

  do_token = "${module.cd.do_token}"
  domain_name = "${module.cd.domain_name}"
  one_time_token_retrieval = "${module.cd.one_time_token_retrieval}"
  gitea_admin_password = "${module.gitea-first-login.admin_password}"
  gocd_admin_password = "${module.saas-providers.gocd_admin_password}"

  module_depends_on = "${module.cd.milestone_setup_complete}${module.providergw.milestone_providergw_ready}${module.providergw-user.milestone_user_created}"

}

