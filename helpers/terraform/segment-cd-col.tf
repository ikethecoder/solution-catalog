resource "digitalocean_droplet" "escd27-cd-col-1" {
    image = 23655208
    name = "escd27-cd-col-1"
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

    provisioner "file" {
        source = "consul.cert"
        destination = "consul.cert"
    }
    provisioner "file" {
            source = "consul.key"
            destination = "consul.key"
    }
    provisioner "file" {
            source = "ca.cert"
            destination = "ca.cert"
    }

    provisioner "file" {
            source = "vault.cert"
            destination = "vault.cert"
    }
    provisioner "file" {
            source = "vault.key"
            destination = "vault.key"
    }

    # Pass the Digital Ocean key to the newly created instance and store in the DO_KEY file
    # The encrypted value is created using the public key from the root user on the image (es15d3-cd-ci-active-id_rsa.pem.pub)
    provisioner "remote-exec" {
        inline = [
            "canzea -v --reset",
            "canzea --decrypt Ze6gLfXyB4EkOzOW2qmBcKro1PtSLeeDKwtSFdTnAXVIsDT-PhzdL9R9mPlW-_-vr9CwDmYKNZn3HvR9h6TH53tLqqDpVjdS9WUgvWTJ2JcUurbEs-XGJvkwZCM427d8U2bYBKRPvh6PezteEXJ2fPa_YbOwMd_ofQis0ipcRUd1rLx3LRmo6GDIV8lWgD3_1cKEhS-cpzUTZqQeU7gqSQpK_dZnYFm7uJJf7-twuR_tChHs-srBdZhQnZIOb1oa0-yXxZ8-RQNGJ-I77odw2uPy1_R-W2SJHAvbqIowI3TckyTg8jTgy47rqU9vk04BZ2H-TQIT05qxSx4OvshWvg== --privateKey=/root/.ssh/id_rsa > DO_KEY"
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
