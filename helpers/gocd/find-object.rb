# ruby helpers/helper-run.rb  gocd list-config-object '{"qualifier":"A", "A":{"type":"pipeline_groups"}}'

require 'json'
require 'net/http'
require_relative './gocd-client.rb'

parameters = JSON.parse(ARGV[0])

qualifier = parameters['qualifier']

# Type: environments, pipelines
type = parameters[qualifier]['type']
name = parameters[qualifier]['name']
version = parameters[qualifier]['version']

cli = GoCDClient.new

cli.findObject version, type, name
