
resource "kubernetes_namespace" "cicd" {
  metadata {
    name = "cicd"
  }
}

