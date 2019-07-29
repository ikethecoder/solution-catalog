
resource "kubernetes_secret" "docker-registry-cicd" {
  metadata {
    name = "docker-registry"
    namespace = "${kubernetes_namespace.cicd.metadata.0.name}"
  }

  data  = {
    docker-server   = "https://registry.ops.${var.domain_name}"
    docker-username = "admin"
    docker-password = "admin"
    docker-email    = "admin@nowhere.com"
  }

  type = "docker-registry"

}

