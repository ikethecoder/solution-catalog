
resource "helm_release" "dev-traefik" {
  name  = "cicd-traefik"
  chart = "stable/traefik"
  namespace = "kube-system"

  recreate_pods = true
  
  values = [
        <<EOF
         dashboard:
            enabled: true
            domain: lb.cloud.${var.domain_name}

         rbac:
            enabled: true

         ssl:
            enabled: true
            enforced: true
            defaultCert: "${base64encode("${acme_certificate.certificate.certificate_pem}\n${acme_certificate.certificate.issuer_pem}")}"
            defaultKey: "${base64encode(acme_certificate.certificate.private_key_pem)}"
        EOF
  ]

  depends_on = [
      "null_resource.helm_init"
  ]

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

resource "digitalocean_record" "cluster" {
  domain = "${var.domain_name}"
  type   = "A"
  name   = "*.cloud"
  value  = "${data.kubernetes_service.traefik.load_balancer_ingress.0.ip}"
  ttl    = "30"
}
