require 'git'
require 'json'
require 'fileutils'
require 'trace-runner'
require 'commands/push-config'

# Config --args='{"src":"abc","dest"}'

params = JSON.parse(ARGV[0])

pc = PushConfig.new "instances/#{params['instanceId']}/"

source = params['source']
target = File.realpath(params['target'])
instanceId = params['instanceId']
solution = params['solution']

if File.exists? target
    # pc.cp target, target
end

pc.cp source, "config/#{solution}#{target}"
puts "Writing to: config/#{solution}#{target}"

FileUtils.cp source, target

pc.commit "Tracking #{target}"
