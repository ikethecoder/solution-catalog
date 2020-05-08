
resource "helm_release" "dev-traefik" {
  name  = "cicd-traefik"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart = "traefik"
  namespace = "kube-system"

  recreate_pods = true
  
  values = [
        <<EOF
         rbac:
            enabled: true
         ssl:
            enabled: true
            enforced: true
            defaultCert: "${base64encode("${acme_certificate.certificate.certificate_pem}\n${acme_certificate.certificate.issuer_pem}")}"
            defaultKey: "${base64encode(acme_certificate.certificate.private_key_pem)}"

        EOF
  ]

  set {
      name  = "dashboard.enabled"
      value = "true"
  }

  set {
      name  = "dashboard.domain"
      value = "lb.${var.workspace}.ws.${var.domain_name}"
  }

}

data "kubernetes_service" "traefik" {
  metadata {
    name = "cicd-traefik"
    namespace = "kube-system"
  }

  depends_on = [
    "helm_release.dev-traefik"
  ]
}
