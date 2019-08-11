module "cd-bootstrap" {
        source = "./modules/cd-bootstrap"
        do = "${var.do}"
        domain_name = "{{domain_name}}"
        region = "{{region}}"
        email = "{{email}}"
        es_id = "{{es_id}}"
        do = "${var.do}"
        ssh_fingerprint = "${module.common.ssh_fingerprint}"
        pvt_key = "${var.pvt_key}"
        instance = "{{instance}}"
}
