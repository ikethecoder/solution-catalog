require 'json'
require 'commands/push-config'
require 'template-runner'

t = Template.new
pc = PushConfig.new

template = %{
    resource "digitalocean_ssh_key" "{{name}}" {
      name       = "{{name}}"
      public_key = "${file("{{props.pub_file}}")}"
    }
}

if ARGV[0].start_with? "@"
    params = JSON.parse(File.read(ARGV[0][1,100]))
else
    params = JSON.parse(ARGV[0])
end

resourceId = params.keys[0]
properties = params[resourceId]

output = t.processString template, {"name":params.keys[0], "props": properties}

puts output
pc.write "terraform/modules/other/#{params.keys[0]}.tf", output
