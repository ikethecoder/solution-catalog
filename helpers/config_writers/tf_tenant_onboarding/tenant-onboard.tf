

module "onboard-tenant-{{tenant_id}}" {
  source = "./modules/onboarding"

  tenant = "{{tenant_id}}"

  do_token = "${module.cd-bootstrap.do_token}"
  domain_name = "${module.cd-bootstrap.domain_name}"
  one_time_token_retrieval = "${module.cd-bootstrap.one_time_token_retrieval}"
  gitea_admin_password = "${module.gitea-first-login.admin_password}"
  gocd_admin_password = "${module.saas-providers.gocd_admin_password}"

  module_depends_on = "${module.cd-bootstrap.milestone_setup_complete}${module.providergw.milestone_providergw_ready}${module.providergw-user.milestone_user_created}"

}

