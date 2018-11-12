require 'json'
require 'commands/push-config'
require 'template-runner'

is_plus = (ARGV[1] == 'PLUS')

t = Template.new
pc = PushConfig.new "/"

template = %{

    resource "digitalocean_volume" "{{rid}}" {
        name = "{{rid}}"
        region = "{{region}}"
        size = "{{size}}"
        initial_filesystem_type = "ext4"
        description = "{{description}}"
    }

    resource "digitalocean_volume_attachment" "{{rid}}" {
      droplet_id = "${digitalocean_droplet.{{droplet}}.id}"
      volume_id  = "${digitalocean_volume.{{rid}}.id}"
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

domainFile = "terraform/modules/#{properties['environment']}/volume-#{properties['rid']}.tf"

if is_plus
    output = t.processString template, properties

    puts output
    pc.write "terraform/modules/#{properties['environment']}/volume-#{resourceId}.tf", output

else
    pc.backupAndRemove "terraform/modules/#{properties['environment']}/volume-#{resourceId}.tf"
end
