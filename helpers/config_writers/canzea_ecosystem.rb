require 'json'
require 'fileutils'
require 'trace-runner'
require "canzea/config"
require 'commands/push-config'

is_plus = (ARGV[1] == 'PLUS')

params = JSON.parse(ARGV[0])

pc = PushConfig.new

resourceId = params.keys[0]
properties = params[resourceId]

key = resourceId

n = RunnerWorker.new(false)

if is_plus
    pc.write("README.md", "# Ecosystem\n\n````\n" + JSON.pretty_generate(params) + "\n\n````")
else
    pc.backupAndRemove "README.md"
end
