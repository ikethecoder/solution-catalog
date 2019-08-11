

output node_cluster {
    value = "${digitalocean_kubernetes_cluster.cluster.node_pool.0.nodes.0.name}"
}

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

output kube_raw_config {
    value = "${digitalocean_kubernetes_cluster.cluster.kube_config.0.raw_config}"
}
