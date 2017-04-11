resource "digitalocean_droplet" "escd27-cd-ci-1" {
    image = 23655208
    name = "escd27-cd-ci-1"
    region = "nyc1"
    size = "4gb"
    private_networking = true
    ssh_keys = [
        "${var.ssh_fingerprint}"
    ]

    connection {
        user = "root"
        type = "ssh"
        private_key = "${file(var.pvt_key)}"
        timeout = "2m"
    }

    # Pass the Digital Ocean key to the newly created instance and store in the DO_KEY file
    # The encrypted value is created using the public key from the root user on the image (es15d3-cd-ci-active-id_rsa.pem.pub)
    provisioner "remote-exec" {
        inline = [
            "canzea -v --reset",
            "canzea --decrypt ROGrL0um2TK3jJnTCPahUP6A2CdJ4DM6uc77jS98LpbljALXoDuSp-QjE9_EZLf_Wva4OQMYcY-1L-5gkVIQJBhafxP8YjHVPltBmVVvwTRaASyJFrjN-iIpYqQ9ZfnlQUYhLwmURk9DXHrDEAP7nSGZHNtKOpaXLqdYLBdEPLkrEDbo4GzcY7O724Pwam-5VwrZ2gOTnw2Us3sahEe8ad6rg-1jUODXhkW-mEEH1qUVHaD0jGeaIpXyhaVpRczLwgVhZOx4AMQrNLfXshP4PGy_4Rb4TOcHjxIFNHJbJLp3dTPQbU0F7Y_t5n7DJxsT3Z7b6RVKuKACQYteTArB8A== --privateKey=/root/.ssh/id_rsa > DO_KEY"
        ]
    }

    /*
    provisioner "remote-exec" {
        inline = [
            "mkdir -p /etc/consul.d/ssl",
            "cp consul.* /etc/consul.d/ssl/.",
            "cp ca.cert /etc/consul.d/ssl/.",
            "cp vault.* /etc/consul.d/ssl/.",
            "echo 'nameserver 10.136.52.218' > /etc/resolv.conf",
                "echo '{\"consul_tls\":true}' > /root/.ecosystem-catalog/config.json",
            "export ECOSYSTEM=escd27",
            "export VAULT_TOKEN=01678d7a-8b99-d184-f664-3cf3a0fd034a",
            "export CONSUL_URL=https://consul.service.dc1.consul:8080",
            "export DIGITALOCEAN_TOKEN=`cat DO_KEY`",
            "export HOSTNAME=`curl -s http://169.254.169.254/metadata/v1/hostname`",
            "export PUBLIC_IPV4=`curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address`",
            "export PRIVATE_IPV4=`curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address`",
            "gem install canzea",
            "cp /root/.ecosystem-catalog/catalog/roles/monitoring/filebeat/config/elastic-beats.repo /etc/yum.repos.d/elastic-beats.repo",
            "cp /root/.ecosystem-catalog/catalog/roles/agilepm/taiga-circus/config/circus.service /usr/lib/systemd/system/circusd.service",
            "yum -y install filebeat",
            "canzea --util=apply-config"
        ]
    }
    */

}

resource "digitalocean_domain" "escd27" {
   name = "escd27.canzea.cc"
   ip_address = "${digitalocean_droplet.escd27-cd-ci-1.ipv4_address}"
}

resource "digitalocean_record" "escd27-www" {
  domain = "${digitalocean_domain.escd27.name}"
  type = "CNAME"
  name = "www"
  value = "@"
}
