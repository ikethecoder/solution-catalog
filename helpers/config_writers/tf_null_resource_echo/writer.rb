require 'json'
require 'set'
require 'commands/push-config'
require 'template-runner'

is_plus = (ARGV[1] == 'PLUS')

t = Template.new
pc = PushConfig.new "/"

template = %{

    resource "null_resource" "{{rid}}" {
        provisioner "local-exec" {
            command = "echo '{{name}}'"
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
properties['rid'] = resourceId;

if ['environment', 'name'].to_set.subtract(properties.keys).length != 0
    raise "Missing Required Fields"
end

outFile = "terraform/modules/#{properties['environment']}/echo-#{properties['rid']}.tf"

if is_plus
    output = t.processString template, properties
    pc.write outFile, output

else
    pc.backupAndRemove outFile
end
