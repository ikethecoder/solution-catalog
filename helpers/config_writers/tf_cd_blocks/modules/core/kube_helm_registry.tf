
resource "helm_release" "docker-registry" {
    name   = "docker-registry"
    chart  = "stable/docker-registry"
    namespace = "${kubernetes_namespace.cicd.metadata.0.name}"

    values = [
        <<EOF
         persistence:
           enabled  : true
           size     : "20Gi"
           deleteEnabled : true
         service:
           type     : NodePort
           nodePort : 30300
        EOF
    ]

    depends_on = [
      "null_resource.helm_init"
    ]
}

data "kubernetes_service" "docker-registry" {
  metadata {
    name = "docker-registry"
    namespace = "${kubernetes_namespace.cicd.metadata.0.name}"
  }
  depends_on = [
    "helm_release.docker-registry"
  ]
}


data "template_file" "nginx_conf_registry" {
  template = "${file("${path.module}/assets/nginx_conf_registry.tpl")}"
  vars = {
    DOMAIN_NAME = "${var.domain_name}"
    IP = "${data.digitalocean_droplet.cluster-node.ipv4_address}"
  }
}

resource "null_resource" "registry-deploy-proxy" {
  triggers = {
    config = "${data.template_file.nginx_conf_registry.rendered}"
  }
  connection {
    host = "${var.base_proxy_ipv4_address}"
    user = "root"
    type = "ssh"
    private_key = "${var.pvt_key_data}"
    timeout = "2m"
  }
 
  provisioner "file" {
    content     = "${data.template_file.nginx_conf_registry.rendered}"
    destination = "/etc/nginx/conf.d/docker-registry.conf"
  }

  provisioner "remote-exec" {

    inline = [
        "nginx -s reload"
    ]
  }

}


resource "digitalocean_firewall" "registry" {
  name = "registry"

  droplet_ids = ["${var.base_droplet_id}"]

  outbound_rule = [
    {
      protocol                = "tcp"
      port_range              = "30300"
      destination_addresses   = ["${data.digitalocean_droplet.cluster-node.ipv4_address}"]
    }
  ]
}

// docker-registry regcred --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>
resource "kubernetes_secret" "docker-registry" {
  metadata {
    name = "docker-registry"
    namespace = "apps"
  }

  data  = {
    docker-server   = "https://registry.ops.${var.domain_name}"
    docker-username = "admin"
    docker-password = "admin"
    docker-email    = "admin@nowhere.com"
  }

  type = "docker-registry"
}

// https://github.com/goharbor/harbor-helm/tree/1.0.0

/*
resource "helm_release" "harbor" {
    name      = "harbor"
    chart     = "stable/harbor"
    namespace = "cicd"

    values = [
        <<EOF
         persistence:
           persistentVolumeClaim:
             registry:
               size: "1Gi"
             jobservice:
               size: "1Gi"
             chartmuseum:
               size: "1Gi"
             database:
               size: "1Gi"
             redis:
               size: "1Gi"
         expose:
           ingress:
             hosts:
               core: harbor.cloud.${var.domain_name}
        EOF
    ]

}

*/
