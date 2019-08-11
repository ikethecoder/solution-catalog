module "{{cluster_id}}" {
        source = "./modules/{{environment}}-cluster"
        do = "${var.do}"
        domain_name = "{{domain_name}}"
        region = "{{region}}"
        do = "${var.do}"
        cluster_id = "{{cluster_id}}"
        kube_version = "{{kube_version}}"
        node_pool_size = "{{node_pool_size}}"
        node_pool_count = "{{node_pool_count}}"
}
