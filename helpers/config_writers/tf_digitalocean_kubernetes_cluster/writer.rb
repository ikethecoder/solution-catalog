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

if ['environment', 'kube_version', 'node_pool_size', 'node_pool_count', 'region', 'domain_name'].to_set.subtract(properties.keys).length != 0
    raise "Missing Required Fields"
end

root = "terraform/modules/#{properties['environment']}"

if is_plus
   # pc.cp __dir__,"terraform/modules/#{properties['environment']}/assets"

   output = t.process "#{__dir__}/kube.tf", properties
   pc.write "#{root}/kube-#{properties['rid']}.tf", output

   output = t.process "#{__dir__}/kube_helm.tf", properties
   pc.write "#{root}/kube-helm-#{properties['rid']}.tf", output

   output = t.process "#{__dir__}/kube_helm_dashboard.tf", properties
   pc.write "#{root}/kube-dashboard-#{properties['rid']}.tf", output

   output = t.process "#{__dir__}/variables.tf", properties
   pc.write "#{root}/variables-#{properties['rid']}.tf", output

   output = t.process "#{__dir__}/output.tf", properties
   pc.write "#{root}/output-#{properties['rid']}.tf", output

else
    pc.backupAndRemove "#{root}/kube-#{properties['rid']}.tf"
    pc.backupAndRemove "#{root}/kube-helm-#{properties['rid']}.tf"
    pc.backupAndRemove "#{root}/kube-dashboard-#{properties['rid']}.tf"
    pc.backupAndRemove "#{root}/variables-#{properties['rid']}.tf"
    pc.backupAndRemove "#{root}/output-#{properties['rid']}.tf"
end
