data "template_file" "nginx_conf_helm" {
  template = "${file("${path.module}/assets/nginx_conf_helm.tpl")}"
  vars = {
    DOMAIN_NAME = "${var.domain_name}"
    IP = "${data.digitalocean_droplet.cluster-node.ipv4_address}"
  }
}

resource "null_resource" "helm-deploy-proxy" {
  triggers = {
    config = "${data.template_file.nginx_conf_helm.rendered}"
  }
  connection {
    host = "${var.base_proxy_ipv4_address}"
    user = "root"
    type = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout = "2m"
  }
 
  provisioner "file" {
    content     = "${data.template_file.nginx_conf_helm.rendered}"
    destination = "/etc/nginx/conf.d/helm.conf"
  }

  provisioner "remote-exec" {

    inline = [
        "git config --global credential.helper store",
        "(cd /var && rm -rf helm-charts && git clone https://github.com/ikethecoder/helm-charts.git)",
        "nginx -s reload"
    ]
  }

}


