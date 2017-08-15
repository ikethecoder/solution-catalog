# canzea --lifecycle=wire --solution=gocd --action=combined/add-agent-to-env --args='{"environment":"perf", "agent":"escd27-perf-app-01"}'

require 'json'
require_relative '../gocd-client'

parameters = JSON.parse(ARGV[0])

env = parameters['environment']

# Make sure there are no spaces in the name of the environment
env.gsub!(' & ', '-')
env.gsub!(' ', '-')

id = parameters['pipeline']

cli = GoCDClient.new '/go/api/admin'

changes = { "pipelines" => { "remove" => [id] } }

cli.getObject '2', 'environments', env
cli.patchObject '2', 'environments', env, changes
