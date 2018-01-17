require 'git'
require 'json'
require 'fileutils'
require 'trace-runner'
require 'commands/push-config'
require 'template-runner'

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

t = Template.new


content = t.process(source, params)
pc.write "config/#{solution}#{target}", content

puts "Writing to: config/#{solution}#{target}"

File.write(target, content)

pc.commit "Tracking #{target}"
