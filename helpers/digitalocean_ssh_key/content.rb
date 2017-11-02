require 'json'
require 'commands/push-config'

pc = PushConfig.new

params = JSON.parse(ARGV[0])

pc.write "terraform/modules/digitalocean_ssh_key/#{params['name']}.tf", JSON.pretty_generate(params)
