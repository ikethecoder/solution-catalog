require 'json'
require_relative './gocd-client.rb'

parameters = JSON.parse(ARGV[0])

qualifier = parameters['qualifier']
type = parameters[qualifier]['type']
name = parameters[qualifier]['name']
version = parameters[qualifier]['version']


# ruby helpers/helper-run.rb gocd enable-agent '{"qualifier":"a","a":{"type":"agents","version":"4","name":"build-b-01"}}'
# ruby helpers/helper-run.rb gocd enable-agent '{"qualifier":"a","a":{"type":"agents","version":"4","name":"integration-c-01"}}'

require_relative('list-objects.rb')

agents = JSON.parse(File.read("agents.json"))

agents = agents['_embedded']['agents']

agents.each do |agent|
 puts agent['uuid'] + " : " + agent['hostname']
 if (agent['hostname'] == name)
    cli = GoCDClient.new

    cli.getObject version, type, agent['uuid']

    jsonObject = cli.retrieveObject type, agent['uuid']

    payload = {
        "agent_config_state" => "Enabled"
    }

    cli.patchObject version, type, agent['uuid'], payload
 end
end


