require 'json'
require 'fileutils'
require 'trace-runner'
require "canzea/config"
require 'commands/push-config'

params = JSON.parse(ARGV[0])

pc = PushConfig.new

resourceId = params.keys[0]
properties = params[resourceId]

key = resourceId

n = RunnerWorker.new(false)

pw.write("README.md", "# Ecosystem\n\n````\n" + JSON.pretty_generate(params) + "\n\n````")

