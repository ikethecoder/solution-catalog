# ruby helpers/helper-run.rb  gocd get-object '{"qualifier":"A","A":{"type":"environments","Integration":""}}'

require 'json'
require 'net/http'
require_relative './gocd-client.rb'

parameters = JSON.parse(ARGV[0])

qualifier = parameters['qualifier']

# Type: environments, pipelines
type = parameters[qualifier]['type']
version = parameters[qualifier]['version']
name = parameters[qualifier]['name']

cli = GoCDClient.new

cli.getObject version, type, name
