module "{{cluster_id}}" {
        source = "./modules/{{environment}}-cluster"
        domain_name = "{{domain_name}}"
        cluster_id = "{{cluster_id}}"
        do = "${var.do}"
        region = "{{region}}"
        kube_version = "{{kube_version}}"
        node_pool_size = "{{node_pool_size}}"
        node_pool_count = "{{node_pool_count}}"
}
