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

if ['block', 'workspace', 'es_id', 'domain_name'].to_set.subtract(properties.keys).length != 0
    raise "Missing Required Fields"
end

root = "terraform"

templates = [
    "module-block"
]

if is_plus
    pc.cp "#{__dir__}/modules","terraform/modules/blocks.2/#{properties['block']}"
    pc.cp "#{__dir__}/../../../blocks/#{properties['block']}/kube/modules","terraform/modules/blocks.2/#{properties['block']}"

    for templ in templates do
        output = t.process "#{__dir__}/#{templ}.tf", properties
        pc.write "#{root}/#{templ}-#{properties['rid']}.tf", output
    end

else
    for templ in templates do
        pc.backupAndRemove "#{root}/#{templ}-#{properties['rid']}.tf"
    end
end
