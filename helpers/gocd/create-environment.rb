# canzea --lifecycle=wire --solution=gocd --action=create-environment --args='{"name":"blunt"}'

require 'json'
require_relative './gocd-client'

parameters = JSON.parse(ARGV[0])

env = parameters['name']

env.gsub!(' & ', '-')
env.gsub!(' ', '-')

payload = {"name" => env}

cli = GoCDClient.new('/go/api/admin')

# If it already exists, then gracefully return
begin
  cli.getObject '2', 'environments', env
rescue
  cli.postObject 2, 'environments', payload
end
