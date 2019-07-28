
data "template_file" "server_agent_json" {
  template = "${file("${path.module}/assets/consul_config.tpl")}"
  vars = {
    NODE_NAME = "consul_s1"
    CONSUL_DATA_PATH = "/var/consul/data"
    ADVERTISE_ADDR = "${digitalocean_droplet.{{instance}}.ipv4_address}"
    JOIN1 = "${digitalocean_droplet.{{instance}}.ipv4_address}"
  }
}

data "template_file" "vault_server_hcl" {
  template = "${file("${path.module}/assets/vault_config.tpl")}"
  vars = {
    API_ADDR = "http://${digitalocean_droplet.{{instance}}.ipv4_address}:8200"
    CLUSTER_ADDR = "https://${digitalocean_droplet.{{instance}}.ipv4_address}:8201"
  }
}

data "template_file" "nginx_conf" {
  template = "${file("${path.module}/assets/nginx_conf.tpl")}"
  vars = {
    DOMAIN_NAME = "${var.domain_name}"
  }
}

data "template_file" "profile_d_sh" {
  template = "${file("${path.module}/assets/profile.d.sh.tpl")}"
  vars = {
    DOMAIN_NAME = "${var.domain_name}"
  }
}

data "archive_file" "dotfiles" {
  type        = "zip"
  output_path = "${path.module}/dotfiles_1.zip"
  source_dir = "${path.module}/assets"
}

data "archive_file" "customfiles" {
  type        = "zip"
  output_path = "${path.module}/dotfiles_2.zip"

  source {
    content  = "${data.template_file.server_agent_json.rendered}"
    filename = "server_agent.json"
  }

  source {
    content  = "${data.template_file.vault_server_hcl.rendered}"
    filename = "vault_server.hcl"
  }

  source {
    content  = "${data.template_file.nginx_conf.rendered}"
    filename = "nginx.conf"
  }

  source {
    content  = "${data.template_file.profile_d_sh.rendered}"
    filename = "profile.d.sh"
  }

  

}


resource "random_string" "one-time-token-retrieval" {
  length = 128
  special = false
  override_special = "/@\" "
}

resource "null_resource" "post-setup" {

  connection {
    host = "${digitalocean_droplet.{{instance}}.ipv4_address}"
    user = "root"
    type = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout = "2m"
  }
 
  provisioner "remote-exec" {

    inline = [
        "mkdir -p /etc/certs"
    ]
  }

  provisioner "file" {
    content     = "${acme_certificate.certificate.private_key_pem}"
    destination = "/etc/certs/host.key"
  }

  provisioner "file" {
    content     = "${acme_certificate.certificate.certificate_pem}"
    destination = "/etc/certs/host.crt"
  }

  provisioner "file" {
    content     = "${acme_certificate.certificate.certificate_pem}\n${acme_certificate.certificate.issuer_pem}"
    destination = "/etc/certs/chain.pem"
  }

  provisioner "file" {
    content     = "${acme_certificate.certificate.issuer_pem}"
    destination = "/etc/certs/issuer.pem"
  }

  provisioner "file" {
    source     = "${path.module}/dotfiles_1.zip"
    destination = "dotfiles_1.zip"
  }

  provisioner "file" {
    source     = "${path.module}/dotfiles_2.zip"
    destination = "dotfiles_2.zip"
  }

  provisioner "file" {
    content     = "${random_string.one-time-token-retrieval.result}"
    destination = ".token-reference"
  }

  provisioner "remote-exec" {

    inline = [
        "unzip dotfiles_1.zip",
        "unzip dotfiles_2.zip",
        "chmod +x prepare.sh",
        "./prepare.sh"
    ]
  }

  depends_on = [
    "digitalocean_droplet.{{instance}}"
  ]
}



