# canzea --lifecycle=wire --solution=gocd --action=combined/add-agent-to-env --args='{"environment":"perf", "agent":"escd27-perf-app-01"}'

require 'json'
require_relative '../gocd-client'

parameters = JSON.parse(ARGV[0])

env = parameters['environment']

id = parameters['agent']

cli = GoCDClient.new

cli.findObject '4', 'agents', id

json = cli.retrieveObject 'agents', id

uuid = json['uuid']


cli = GoCDClient.new '/go/api/admin'

changes = { "agents" => [ { "uuid" => uuid } ] }

cli.getObject '2', 'environments', env
cli.patchObject '2', 'environments', env, changes
