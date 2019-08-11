module "{{cluster_id}}-setup" {
        source = "./modules/{{environment}}-cluster-setup"
        domain_name = "{{domain_name}}"
        node_cluster = "${module.{{cluster_id}}.node_cluster}"
        base_proxy_ipv4_address = "${module.cd-bootstrap.base_proxy_ipv4_address}"

        pvt_key = "${var.pvt_key}"
        
        kube_host = "${module.{{cluster_id}}.kube_host}"
        kube_client_certificate = "${module.{{cluster_id}}.kube_client_certificate}"
        kube_client_key = "${module.{{cluster_id}}.kube_client_key}"
        kube_cluster_ca_certificate = "${module.{{cluster_id}}.kube_cluster_ca_certificate}"
}

