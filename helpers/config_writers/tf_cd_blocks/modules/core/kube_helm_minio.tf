resource "helm_release" "minio" {
    name      = "minio"
    chart     = "stable/minio"
    namespace = "cicd"

    values = [
        <<EOF
         # s3gateway.enabled
         # s3gateway.serviceEndpoint
         persistence:
           enabled: true
           size: "5Gi"

         ingress:
            enabled: true
            hosts:
            - minio.cloud.${var.domain_name}
        EOF
    ]

}
