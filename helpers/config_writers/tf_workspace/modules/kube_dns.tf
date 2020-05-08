
resource "digitalocean_record" "cluster" {
  domain = "${var.domain_name}"
  type   = "A"
  name   = "*.${var.workspace}.ws"
  value  = "${data.kubernetes_service.traefik.load_balancer_ingress.0.ip}"
  ttl    = "30"
}
