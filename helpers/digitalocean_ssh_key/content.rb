require 'json'
require 'commands/push-config'

pc = PushConfig.new

params = JSON.parse(ARGV[0])

pc.write "ssh_key_sample", JSON.pretty_generate(params)
