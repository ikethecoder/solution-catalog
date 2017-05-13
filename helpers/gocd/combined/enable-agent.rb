require_relative '../gocd-client'

cli = GoCDClient.new

cli.findObject '4', 'agents', 'escd27-perf-app-01'


json = cli.retrieveObject 'agents', 'escd27-perf-app-01'

uuid = json['uuid']

cli.getObject '4', 'agents', uuid

changes = {'agent_config_state' => 'Enabled'}

cli.patchObject '4', 'agents', uuid, changes
