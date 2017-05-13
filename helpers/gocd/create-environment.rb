# canzea --lifecycle=wire --solution=gocd --action=create-environment --args='{"name":"blunt"}'

require 'json'
require_relative './gocd-client'

parameters = JSON.parse(ARGV[0])

name = parameters['name']

File.write("environments-#{name}.json", "{\"name\":\"#{name}\"}")

cli = GoCDClient.new

