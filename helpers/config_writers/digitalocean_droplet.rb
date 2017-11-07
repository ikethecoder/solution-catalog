require 'json'
require 'commands/push-config'
require 'template-runner'

is_plus = (ARGV[1] == 'PLUS')

t = Template.new
pc = PushConfig.new

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

        connection {
            user = "root"
            type = "ssh"
            private_key = "${file(var.pvt_key)}"
            timeout = "2m"
        }

        provisioner "remote-exec" {
            inline = [
                "export ES_ENC_DATA={{encdata}}",
                "export ECOSYSTEM={{ecosystem}}",
                "export ECOSYSTEM_ENV=production",
                "export VAULT_URL=https://vault.service.dc1.consul:8080",
                "export HOSTNAME=`curl -s http://169.254.169.254/metadata/v1/hostname`",
                "export PUBLIC_IPV4=`curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address`",
                "export PRIVATE_IPV4=`curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address`"
            ]
        }
    }
}

if ARGV[0].start_with? "@"
    params = JSON.parse(File.read(ARGV[0][1,100]))
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

if is_plus
    output = t.processString template, properties

    puts "terraform/modules/#{properties['environment']}/#{resourceId}.tf", output
    pc.write "terraform/modules/#{properties['environment']}/#{resourceId}.tf", output
else
    pc.backupAndRemove "terraform/modules/#{properties['environment']}/#{resourceId}.tf"
end
