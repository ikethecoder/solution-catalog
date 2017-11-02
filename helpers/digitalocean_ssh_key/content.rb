require 'json'
require 'commands/push-config'

pc = PushConfig.new

params = JSON.parse(ARGV[0])

obj = params[params.keys[0]]

pc.write "terraform/modules/digitalocean_ssh_key/#{obj['name']}.tf", JSON.pretty_generate(params)
