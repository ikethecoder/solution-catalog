

resource "digitalocean_droplet" "{{instance}}" {
  image  = "ubuntu-18-04-x64"
  name   = "{{instance}}"
  region = "${var.region}"
  size   = "s-1vcpu-1gb"
  private_networking = "true"

  ssh_keys = [
      "${var.ssh_fingerprint}"
  ]

  connection {
      user = "root"
      type = "ssh"
      private_key = "${file(var.pvt_key)}"
      timeout = "2m"
  }


  provisioner "remote-exec" {
    inline = [
      "apt install -y unzip",
      "curl -L -O https://releases.hashicorp.com/vault/1.0.2/vault_1.0.2_linux_amd64.zip",
      "unzip vault_1.0.2_linux_amd64.zip && cp vault /usr/local/bin && rm vault*",
      "curl -L -O https://releases.hashicorp.com/consul/1.4.2/consul_1.4.2_linux_amd64.zip",
      "unzip consul_1.4.2_linux_amd64.zip && cp consul /usr/local/bin && rm consul*",
#      "consul join ${aws_instance.web.private_ip}",
      "apt update && apt install -y nginx"
    ]
  }  

}

output "ip" {
    value = "${digitalocean_droplet.{{instance}}.ipv4_address}"
}

