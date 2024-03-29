require 'json'
require 'commands/push-config'
require 'template-runner'

is_plus = (ARGV[1] == 'PLUS')

t = Template.new
pc = PushConfig.new "/"

template = %{

    resource "digitalocean_droplet" "{{name}}" {
        image = {{{imageText}}}
        name = "{{name}}"
        region = "{{region}}"
        size = "{{size}}"
        private_networking = true
        ssh_keys = [
            "${var.ssh_fingerprint}"
        ]
  {{#_tags.length}}
        tags = {{{_tags}}}
  {{/_tags.length}}

        connection {
            user = "root"
            type = "ssh"
            private_key = "${file(var.pvt_key)}"
            timeout = "2m"
        }

  {{#tls_setup}}
        provisioner "remote-exec" {
            inline = [
                "mkdir -p /var/local/consul/ssl"
            ]
        }

        provisioner "file" {
            source = "./.es/consul.cert"
            destination = "/var/local/consul/ssl/consul.cert"
        }
        provisioner "file" {
            source = "./.es/consul.key"
            destination = "/var/local/consul/ssl/consul.key"
        }
        provisioner "file" {
            source = "./.es/ca.cert"
            destination = "/var/local/consul/ssl/ca.cert"
        }
        provisioner "file" {
            source = "./.es/vault.cert"
            destination = "/var/local/consul/ssl/vault.cert"
        }
        provisioner "file" {
            source = "./.es/vault.key"
            destination = "/var/local/consul/ssl/vault.key"
        }
  {{/tls_setup}}

  {{#gateway_pub}}
        provisioner "file" {
            source = "./.es/root_id_rsa.pub"
            destination = "/root/.ssh/gateway_id_rsa.pub"
        }

        provisioner "remote-exec" {
            inline = [
                "cat /root/.ssh/gateway_id_rsa.pub >> /root/.ssh/authorized_keys"
            ]
        }

  {{/gateway_pub}}

  {{#_nameserver}}
        provisioner "remote-exec" {
            inline = [
                "printf 'nameserver {{_nameserver}}\\nsearch localdomain\\n' > /etc/resolv.conf"
            ]
        }
  {{/_nameserver}}

        provisioner "remote-exec" {
            inline = [
                "export ES_ENC_DATA={{encdata}}",
                "export ECOSYSTEM={{ecosystem}}",
                "export ES_DOMAIN={{fqdn}}",
                "export ECOSYSTEM_ENV=production",
                "export VAULT_URL=https://vault.service.dc1.consul:8080",
                "export HOSTNAME=`curl -s http://169.254.169.254/metadata/v1/hostname`",
                "export PUBLIC_IPV4=`curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address`",
                "export PRIVATE_IPV4=`curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address`",
                "echo 'export ECOSYSTEM={{ecosystem}} && export ES_DOMAIN={{fqdn}} && export HOSTNAME=`hostname`' > /etc/profile.d/canzea.sh"
            ]
        }
    }
}

if ARGV[0].start_with? "@"
    params = JSON.parse(File.read(ARGV[0][1,200]))
else
    params = JSON.parse(ARGV[0])
end

resourceId = params.keys[0]
properties = params[resourceId]
properties['name'] = resourceId;

if (properties.has_key? "imagePaasId")
    properties[:imageText] = properties['imagePaasId'].to_i
else
    properties[:imageText] = "\"#{properties['imageCode']}\""
end

if properties.has_key? "tls_setup"
    properties['tls_setup'] = ["-dummy-"]
end

properties['_tags'] = []

if properties.has_key? "tags"
    properties['tags'].each { |key|
        safeKey = key.gsub(/-/, '_')
        properties['_tags'].push "${var.digitalocean_tag_#{safeKey}_id}"
    }
end

if is_plus
    output = t.processString template, properties

    puts "terraform/modules/#{properties['environment']}/#{resourceId}.tf", output
    pc.write "terraform/modules/#{properties['environment']}/#{resourceId}.tf", output
else
    pc.backupAndRemove "terraform/modules/#{properties['environment']}/#{resourceId}.tf"
end
