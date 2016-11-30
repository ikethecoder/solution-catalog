require 'json'
require_relative './gocd-client.rb'

parameters = JSON.parse(ARGV[0])

qualifier = parameters['qualifier']
type = parameters[qualifier]['type']
name = parameters[qualifier]['name']
version = parameters[qualifier]['version']
envName = parameters[qualifier]['envName']

# ruby helpers/helper-run.rb gocd link-agent-to-environment '{"qualifier":"a","a":{"type":"agents","version":"4","name":"build-a-01","envName":"Build"}}'
# ruby helpers/helper-run.rb gocd link-agent-to-environment '{"qualifier":"a","a":{"type":"agents","version":"4","name":"integration-c-01","envName":"Integration"}}'

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
        "environments" => envName
    }

    cli.patchObject version, type, agent['uuid'], payload
 end
end


