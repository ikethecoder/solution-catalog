# canzea --lifecycle=wire --solution=gocd --action=combined/enable-agent --args='{"agent":"escd27-perf-app-01"}'

require 'json'
require_relative '../gocd-client'

parameters = JSON.parse(ARGV[0])

id = parameters['agent']

cli = GoCDClient.new

cli.findObject '4', 'agents', id


json = cli.retrieveObject 'agents', id

uuid = json['uuid']

cli.getObject '4', 'agents', uuid

changes = {'agent_config_state' => 'Enabled'}

cli.patchObject '4', 'agents', uuid, changes
