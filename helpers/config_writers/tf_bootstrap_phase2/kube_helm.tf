
resource "helm_repository" "private" {
    name = "private"
    url  = "https://helm.ops.${var.domain_name}/charts"

    depends_on = [
        "null_resource.helm-deploy-proxy"
    ]
}
