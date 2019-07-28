
output do_token {
    value = "${var.do_token}"
}

output domain_name {
    value = "${digitalocean_domain.default.name}"
}

output pvt_key_data {
    value = "${file(var.pvt_key)}"
}



output domain_tls_certificate_pem {
    value = "${acme_certificate.certificate.certificate_pem}"
}

output domain_tls_issuer_pem {
    value = "${acme_certificate.certificate.issuer_pem}"
}

output domain_tls_private_key_pem {
    value = "${acme_certificate.certificate.private_key_pem}"
}


/*
output node_cluster_collab {
    value = "${digitalocean_kubernetes_node_pool.collab.nodes.0.name}"
}
*/

output base_droplet_id {
    value = "${digitalocean_droplet.{{instance}}.id}"
}

output base_proxy_ipv4_address {
    value = "${digitalocean_droplet.{{instance}}.ipv4_address}"
}


output one_time_token_retrieval {
    value = "${random_string.one-time-token-retrieval.result}"
}

output milestone_setup_complete {
    value = "COMPLETE"
    depends_on = [
        "null_resource.post-setup"
    ]
}