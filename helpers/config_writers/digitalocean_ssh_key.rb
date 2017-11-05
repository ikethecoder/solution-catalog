require 'json'
require 'commands/push-config'
require 'template-runner'

t = Template.new
pc = PushConfig.new

template = %{
    resource "digitalocean_ssh_key" "{{rid}}" {
      name       = "{{rid}}"
      public_key = "${file(var.{{pub_file}})}"
    }

    output "ssh_fingerprint" {
        value = "${digitalocean_ssh_key.{{rid}}.fingerprint}"
    }
}

if ARGV[0].start_with? "@"
    params = JSON.parse(File.read(ARGV[0][1,100]))
else
    params = JSON.parse(ARGV[0])
end

resourceId = params.keys[0]
properties = params[resourceId]
properties['rid'] = resourceId;

output = t.processString template, properties

puts output
pc.write "terraform/modules/common/#{params.keys[0]}.tf", output
