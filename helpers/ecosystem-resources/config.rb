require 'git'
require 'json'
require 'fileutils'
require 'trace-runner'
require 'commands/push-config'

pc = PushConfig.new "config"

# Config --args='{"src":"abc","dest"}'

params = JSON.parse(ARGV[0])

source = params['source']
target = File.realpath(params['target'])

if File.exists? target
    pc.cp target target
end

pc.cp source target

FileUtils.cp source target

pc.commit "Tracking #{target}"


