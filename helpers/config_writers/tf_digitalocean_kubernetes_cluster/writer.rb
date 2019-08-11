require 'json'
require 'set'
require 'fileutils'
require 'commands/push-config'
require 'template-runner'

is_plus = (ARGV[1] == 'PLUS')

t = Template.new
pc = PushConfig.new "/"

if ARGV[0].start_with? "@"
    params = JSON.parse(File.read(ARGV[0][1,100]))
else
    params = JSON.parse(ARGV[0])
end

resourceId = params.keys[0]
properties = params[resourceId]
properties['rid'] = resourceId

if ['environment', 'cluster_id', 'domain_name'].to_set.subtract(properties.keys).length != 0
    raise "Missing Required Fields"
end

root = "terraform/modules/#{properties['environment']}-cluster"

templates = [
    "module-cluster"
]

if is_plus
    pc.cp "#{__dir__}/modules","#{root}"

    for templ in templates do
        output = t.process "#{__dir__}/#{templ}.tf", properties
        pc.write "terraform/#{templ}-#{properties['rid']}.tf", output
    end

else
    for t in templates do
        pc.backupAndRemove "terraform/#{t}-#{properties['rid']}.tf"
    end
end
