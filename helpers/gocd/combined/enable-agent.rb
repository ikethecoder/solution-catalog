require_relative '../gocd-client'

cli = GoCDClient.new

cli.findObject '4', 'agents', 'escd27-perf-app-01'


json = cli.retrieveObject 'agents', 'escd27-perf-app-01'

json['agent_config_state'] = 'Enabled'

cli.putObject '4', 'agents', 'escd27-perf-app-01', json
