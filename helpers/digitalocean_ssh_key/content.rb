require 'json'
require 'commands/push-config'
require 'template-runner'

t = Template.new
pc = PushConfig.new

params = JSON.parse(ARGV[0])

obj = params[params.keys[0]]

output = t.process "#{ENV['CATALOG_LOCATION']}/helpers/digitalocean_ssh_key/template.rb", {"name":params.keys[0], "data": obj}

pc.write "terraform/modules/digitalocean_ssh_key/#{params.keys[0]}.tf", output
