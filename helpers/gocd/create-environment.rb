# canzea --lifecycle=wire --solution=gocd --action=create-environment --args='{"name":"blunt"}'

require 'json'
require_relative './gocd-client'

parameters = JSON.parse(ARGV[0])

name = parameters['name']

payload = {"name" => name}

cli = GoCDClient.new('/go/api/admin')

cli.postObject 4, 'environments', name, payload