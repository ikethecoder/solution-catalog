output kube_host {
    value = "${digitalocean_kubernetes_cluster.cluster.endpoint}"
}

output kube_client_certificate {
    value = "${base64decode(digitalocean_kubernetes_cluster.cluster.kube_config.0.client_certificate)}"
}

output kube_client_key {
    value = "${base64decode(digitalocean_kubernetes_cluster.cluster.kube_config.0.client_key)}"
}

output kube_cluster_ca_certificate {
    value = "${base64decode(digitalocean_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)}"
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
